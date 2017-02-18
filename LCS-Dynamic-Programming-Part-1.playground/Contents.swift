//: Playground - noun: a place where people can play

import UIKit

// Hack convention
// Don't mess up with Range in Swift 3
extension String {
    func charAt(_ i: Int) -> String {
        return String((self as NSString).character(at: i))
    }
}

/////////////////////////////
// DYNAMIC PROGRAMMING APPROACH
/////////////////////////////

//// Extension of Array
// But we must ensure, each element must adopt with <Equatable> protocol -> We can make comparision
extension Array where Element: Equatable {
    
    func LCS(_ other: [Element]) -> [Element] {
        
        // Build memorization table
        let table = MemorizationTable.buildTable(x: self, y: other)
        
        // Print LCS
        return self.lcsFromMemorizationTable(table)
    }
    
    fileprivate func lcsFromMemorizationTable(_ table: [[Int]]) -> [Element] {
        
    }
}

struct MemorizationTable<T: Equatable> {
    
    static func buildTable(x: [T], y: [T]) -> [[Int]] {
        
        // Create 2-dimension table, and filled with zero
        let m = x.count
        let n = y.count
        var table = Array(repeating: Array(repeating: 0, count: m + 1), count: n + 1)
        
        // Iterate from top-left corner -> bottom-right corner
        for i in 0...n {
            for j in 0...m {
                if i == 0 || j == 0 {
                    table[i][j] = 0
                }
                else if x[i - 1] == y[j-1] { // MATCH
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
