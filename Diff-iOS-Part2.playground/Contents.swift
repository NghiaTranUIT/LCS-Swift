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
struct Diff<T> {
    
    typealias Element = DiffTransform<T>
    
    // Result
    private var _result: [Element] = []
    var result: [Element] {
        return self._result
    }
    
    // Insert
    var insertion: [Element] {
        return self.result.filter({ $0.isInsertion })
    }
    
    // Deletion
    var deletion: [Element] {
        return self.result.filter({ $0.isDeletion })
    }
    
    // Reload
    var reload: [Element] {
        return self.result.filter({ $0.isReload })
    }
    
    mutating func append(item: Element) {
        self._result.append(item)
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
        else if table[i][j] == table[i-1][j] { // Insert
            return diffFromMemorizationTable(table, x, y, i, j-1) + DiffTransform.insert(j-1, y[j-1])
        }
        else if table[i][j] == table[i][j-1] { // Delete
            return diffFromMemorizationTable(table, x, y, i-1, j) + DiffTransform.delete(i-1, x[i-1])
        }
        else { // Reload
            return diffFromMemorizationTable(table, x, y, i-1, j-1) + DiffTransform.reload(i-1, x[i-1])
        }
    }
}

