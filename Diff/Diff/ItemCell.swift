//
//  ItemCell.swift
//  Diff
//
//  Created by Nghia Tran on 3/3/17.
//  Copyright © 2017 nghiatran. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(imageName: String) {
        
// My Purpose
// Don't Cache image in memory
// Just make it complex to render -> Easier to analytic in Instrustment
let path = Bundle.main.path(forResource: imageName, ofType: "jpg")!
let image = UIImage(contentsOfFile: path)

self.imageView.image = image
    }
}
