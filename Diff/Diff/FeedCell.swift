//
//  FeedCell.swift
//  Diff
//
//  Created by Nghia Tran on 2/25/17.
//  Copyright © 2017 nghiatran. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    fileprivate var feedObj: FeedObj!
    
    //
    // MARK: - OUTLET
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //
    // MARK: - View Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure Collection View
        self.collectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    func configureCell(feedObj: FeedObj) {
        
        self.feedObj = feedObj
        self.commentLbl.text = feedObj.content
        self.nameLbl.text = feedObj.title
        
        self.collectionView.reloadData()
    }
}

extension FeedCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedObj.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.configureCell(imageName: self.feedObj.images[indexPath.item])
        return cell
    }
}
