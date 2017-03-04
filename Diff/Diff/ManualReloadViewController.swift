//
//  ManualReloadViewController.swift
//  Diff
//
//  Created by Nghia Tran on 3/3/17.
//  Copyright © 2017 nghiatran. All rights reserved.
//

import UIKit

class ManualReloadViewController: UIViewController {

    //
    // MARK: - Variable
    fileprivate var feedObjs: [FeedObj] = FeedObj.reallyLargeDataSource(loopCount: initialDataLoopCount)
    fileprivate var isPulled = false
    
    //
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshBtn: UIBarButtonItem!
    
    //
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup table view
        self.tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.tableFooterView = UIView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @IBAction func refreshBtnTapped(_ sender: Any) {
        
        // New data
        let _ = !self.isPulled ? FeedObj.pullNewLargeDataSource(loopCount: initialDataLoopCount) :
                                 FeedObj.reallyLargeDataSource(loopCount: pullRefreshDataLoopCount)
        
        /*
        // How we calculate ???
         
        let initalData = [data_1, data_2, data_3, data_4, data_5, data_6, data_7, data_8, data_9, data_10]
        let newData = [data_1, data_4, data_5, data_6, data_3, data_9, data_2]
         
        */
        let insertIndexPaths: [IndexPath] = []
        let deleteIndexPaths: [IndexPath] = []
        
        // 
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: insertIndexPaths, with: UITableViewRowAnimation.none)
        self.tableView.deleteRows(at: deleteIndexPaths, with: UITableViewRowAnimation.none)
        self.tableView.endUpdates()
    }
}

extension ManualReloadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedObjs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        
        let feedObj = self.feedObjs[indexPath.row]
        cell.configureCell(feedObj: feedObj)
        
        return cell
    }
}
