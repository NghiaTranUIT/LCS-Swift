//
//  FeedCell.swift
//  Diff
//
//  Created by Nghia Tran on 2/25/17.
//  Copyright © 2017 nghiatran. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    //
    // MARK: - OUTLET
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    
    //
    // MARK: - View Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(feedObj: FeedObj) {
        
        self.commentLbl.text = feedObj.content
        self.nameLbl.text = feedObj.title
    }
}
