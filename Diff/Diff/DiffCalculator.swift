//
//  DiffCaculator.swift
//  Diff
//
//  Created by Nghia Tran on 2/24/17.
//  Copyright © 2017 nghiatran. All rights reserved.
//

import UIKit

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
        
        print("Diff = \(diff)")
        
        
        tableView.beginUpdates()
        
        // 💯 perfect
        let insertion = diff.insertion.map({ IndexPath(row: $0.index, section: 0) })
        let deletion = diff.deletion.map({ IndexPath(row: $0.index, section: 0) })
        let reload = diff.reload.map({ IndexPath(row: $0.index, section: 0) })
        
        // Delete
        tableView.deleteRows(at: deletion, with: .none)
        tableView.insertRows(at: insertion, with: .none)
        tableView.reloadRows(at: reload, with: .none)
        
        tableView.endUpdates()
    }
}
