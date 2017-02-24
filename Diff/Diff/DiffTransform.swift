//
//  DiffTransform.swift
//  Diff
//
//  Created by Nghia Tran on 2/24/17.
//  Copyright © 2017 nghiatran. All rights reserved.
//

import Foundation

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
