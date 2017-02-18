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
        return self.lcsFromMemorizationTable(table, self, other, self.count, other.count)
    }
    
    fileprivate func lcsFromMemorizationTable(_ table: [[Int]], _ x: [Element], _ y: [Element], _ i: Int, _ j: Int) -> [Element] {
        
        // Exit
        if i == 0 || j == 0 {
            return []
        }
        
        // Recurvise 
        else if x[i-1] == y[j-1] { // MATCH -> Get element
            return lcsFromMemorizationTable(table, x, y, i - 1, j - 1) + [x[i-1]]
        }
        else if table[i-1][j] > table[i][j-1] { // Top
            return lcsFromMemorizationTable(table, x, y, i - 1, j)
        }
        else { // Left
            return lcsFromMemorizationTable(table, x, y, i, j - 1)
        }
    }
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


////////////////////////
////// TEST with string
let a = "acbaed".characters.map { char -> String in
    return String(char)
}
let b = "abcadfa".characters.map { char -> String in
    return String(char)
}
let lcs = a.LCS(b) // ["a", "b", "a", "d"]



//////////////////////////
// Test with custom model
struct UserObj: CustomStringConvertible {
    let name: String!

    var description: String {
        return "{\(self.name!)}"
    }
}

// Adopt Equatable
extension UserObj: Equatable {
    public static func ==(lhs: UserObj, rhs: UserObj) -> Bool {
        return lhs.name == rhs.name
    }
}

let localUsers = [UserObj(name: "Nghia Tran"), UserObj(name: "nghiatran.me"), UserObj(name: "SaiGon"), UserObj(name: "Algorithm")]
let remoteUsers = [UserObj(name: "Kamakura"), UserObj(name: "Nghia Tran"), UserObj(name: "Algorithm"), UserObj(name: "SaiGon"), UserObj(name: "Somewhere")]

// LCS
let lcsUser = localUsers.LCS(remoteUsers)
print(lcsUser) // "[{Nghia Tran}, {Algorithm}]"
