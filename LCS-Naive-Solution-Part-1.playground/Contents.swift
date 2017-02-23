//: Playground - noun: a place where people can play

import UIKit

// Hack convention
// Don't mess up with Range from Swift 3
extension String {
    func charAt(_ i: Int) -> String {
        return String((self as NSString).character(at: i))
    }
}

/////////////////////////////
// NAIVE APPROACH
/////////////////////////////
// Recurvise func to length of LCS
func LCS(_ a: String, _ b: String) -> Int{
    
    // Exit
    if a.characters.count
        == 0 || b.characters.count == 0 {
        return 0
    }
    
    // Prepare
    let lengthA = a.characters.count
    let lengthB = b.characters.count
    let aIndex = a.index(a.endIndex, offsetBy: -1)
    let bIndex = b.index(b.endIndex, offsetBy: -1)

    // Sub-problem
    if a.charAt(lengthA - 1) == b.charAt(lengthB - 1) {
        // MATCH
        return 1 + LCS(a.substring(to: aIndex), b.substring(to: bIndex))
    } else {
        // NOT MATCH
        return max(LCS(a.substring(to: aIndex), b), LCS(a, b.substring(to: bIndex)))
    }
}


// Test
let a = "acbaed"
let b = "abcadf"
print(LCS(a, b))

// Unicode
let x = "😇🙌😉💰🎹"
let y = "🙌🍒💰✈️🎹😎🔴"
print(LCS(x, y))

extension String {
    func `subscript`(range: ClosedRange) -> String {
        return "abc"
    }
}

let sub = a[0..1]