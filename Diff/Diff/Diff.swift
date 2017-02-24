//
//  Diff.swift
//  Diff
//
//  Created by Nghia Tran on 2/24/17.
//  Copyright © 2017 nghiatran. All rights reserved.
//

import Foundation

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
