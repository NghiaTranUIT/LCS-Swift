//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

// Transform
enum DiffTransform<T> {
    
    // Represent for reload/insert/delete in tableView
    // Int: index need to be transform
    // T: generic data
    case reload(Int, T)
    case insert(Int, T)
    case delete(Int, T)
    
}

// Helper
extension DiffTransform: CustomStringConvertible, CustomDebugStringConvertible {
    
    // Value - quick access
    var value: T {
        switch self {
        case .reload( _, let value):
            return value
        case .insert( _, let value):
            return value
        case .delete( _, let value):
            return value
        }
    }
    
    // index - quick access
    var index: Int {
        switch self {
        case .reload(let index, _):
            return index
        case .insert(let index, _):
            return index
        case .delete(let index, _):
            return index
        }
    }
    
    // Is insertion
    var isInsertion: Bool {
        switch self {
        case .insert:
            return true
        default:
            return false
        }
    }
    
    // Is Deletion
    var isDeletion: Bool {
        switch self {
        case .delete:
            return true
        default:
            return false
        }
    }
    
    // Is insertion
    var isReload: Bool {
        switch self {
        case .reload:
            return true
        default:
            return false
        }
    }
    
    // CustomStringConvertible
    var description: String {
        return self.toString
    }
    
    // CustomDebugStringConvertible
    var debugDescription: String {
        return self.toString
    }
    
    // [Private] To string
    private var toString: String {
        switch self {
        case .reload(let index, let value):
            return "Reload((\(index))[\(value)])"
        case .insert(let index, let value):
            return "Insert((\(index))[\(value)])"
        case .delete(let index, let value):
            return "Delete((\(index))[\(value)])"
        }
    }
}

// Diff Container
struct Diff<T>: CustomStringConvertible {
    
    typealias Element = DiffTransform<T>
    
    // Result
    private var _result: [Element] = []
    var result: [Element] {
        return self._result
    }
    
    // Insert
    var insertion: [Element] {
        return self.result.filter({ $0.isInsertion }).sorted(by: { $0.index < $1.index })
    }
    
    // Deletion
    var deletion: [Element] {
        return self.result.filter({ $0.isDeletion }).sorted(by: { $0.index > $1.index })
    }
    
    // Reload
    var reload: [Element] {
        return self.result.filter({ $0.isReload })
    }
    
    mutating func append(item: Element) {
        self._result.append(item)
    }
    
    var description: String {
        return "\(self.result)"
    }
}


func +<T> ( left: Diff<T>, right: DiffTransform<T>) -> Diff<T> {
    var left = left
    left.append(item: right)
    return left
}

// Memorization table
struct MemorizationTable<T: Equatable> {
    
    static func buildTable(x: [T], y: [T]) -> [[Int]] {
        
        // Create 2-dimension table, and filled with zero
        let n = x.count
        let m = y.count
        var table = Array(repeating: Array(repeating: 0, count: m + 1), count: n + 1)
        
        // Iterate from top-left corner -> bottom-right corner
        for i in 0...n {
            for j in 0...m {
                if i == 0 || j == 0 {
                    table[i][j] = 0
                }
                else if x[i-1] == y[j-1] { // MATCH
                    table[i][j] = table[i-1][j-1] + 1
                }
                else { // NOT MATCH
                    table[i][j] = max(table[i-1][j], table[i][j-1])
                }
            }
        }
        
        return table
    }
}

// But we must ensure, each element must adopt with <Equatable> protocol -> We can make comparision
extension Array where Element: Equatable {
    
    func diff(_ other: [Element]) -> Diff<Element> {
        
        // Build memorization table
        let table = MemorizationTable.buildTable(x: self, y: other)
        
        // Print LCS
        return Array.diffFromMemorizationTable(table, self, other, self.count, other.count)
    }
    
    fileprivate static func diffFromMemorizationTable(_ table: [[Int]], _ x: [Element], _ y: [Element], _ i: Int, _ j: Int) -> Diff<Element> {
        
        // Exit
        if i == 0 && j == 0 {
            return Diff<Element>()
        }
        else if i == 0 { // Insert
            return diffFromMemorizationTable(table, x, y, i, j-1) + DiffTransform.insert(j-1, y[j-1])
        }
        else if j == 0 { // Delete
            return diffFromMemorizationTable(table, x, y, i-1, j) + DiffTransform.delete(i-1, x[i-1])
        }
        else if table[i][j] == table[i-1][j] { // Delete
            return diffFromMemorizationTable(table, x, y, i-1, j) + DiffTransform.delete(i-1, x[i-1])
        }
        else if table[i][j] == table[i][j-1] { // Insert
            return diffFromMemorizationTable(table, x, y, i, j-1) + DiffTransform.insert(j-1, y[j-1])
        }
        else { // Reload
            return diffFromMemorizationTable(table, x, y, i-1, j-1) + DiffTransform.reload(i-1, x[i-1])
        }
    }
    
    // Apply Diff
    func apply(_ diff: Diff<Element>) -> [Element] {
        var copy = self
        
        // Delete first
        for delete in diff.deletion {
            copy.remove(at: delete.index)
        }
        
        // Insert
        for insert in diff.insertion {
            copy.insert(insert.value, at: insert.index)
        }
        
        return copy
    }
}


// Test
let a = ["A", "D", "F", "G", "T"]
let b = ["A", "F", "O", "X", "T"]
let diff = a.diff(b)
let c = a.apply(diff)
print(c)

// UITable View Integration
struct DiffCalculator<T: Equatable> {
    
    // Weak table view
    weak var tableView: UITableView?
    
    // Data
    private var _data: [T] = []
    var data: [T] {
        get {return self._data}
        set {
            let old = self._data
            let diff = old.diff(newValue)
            
            // Set
            self._data = newValue
            
            // Transform
            self.applyTransform(with: diff)
        }
    }
    //
    // MARK: - Init
    init(tableView: UITableView, data: [T]) {
        self.tableView = tableView
        self._data = data
    }
    
    // Apply Transfrom
    fileprivate func applyTransform<T: Equatable>(with diff: Diff<T>) {
        
        // Update transform
        guard diff.result.count > 0 else {return}
        guard let tableView = self.tableView else {return}
        
        tableView.beginUpdates()
        
        // Map indexPath
        let insertion = diff.insertion.map({ IndexPath(row: $0.index, section: 0) })
        let deletion = diff.deletion.map({ IndexPath(row: $0.index, section: 0) })
        let reload = diff.reload.map({ IndexPath(row: $0.index, section: 0) })
        
        // Delete
        tableView.deleteRows(at: insertion, with: .automatic)
        tableView.insertRows(at: deletion, with: .automatic)
        tableView.reloadRows(at: reload, with: .automatic)
        
        tableView.endUpdates()
    }
}

// Example
let tableView = UITableView()
let data = ["Nghia Tran", "nghiatran.me", "Saigon", "Singapore", "Bangkok"]
var diffCalculator = DiffCalculator<String>(tableView: tableView, data: data)

// Pull to refresh with new data
let newData = ["Nghia Tran", "Uni", "nghiatran.me", "Ha Noi", "KL", "Singapore", "Bangkok", "Finland"]
diffCalculator.data = newData