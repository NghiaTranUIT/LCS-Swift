//
//  FeedItem.swift
//  Diff
//
//  Created by Nghia Tran on 2/25/17.
//  Copyright © 2017 nghiatran. All rights reserved.
//

import Foundation
import UIKit

class FeedObj {
    
    var title: String!
    var content: String!
    var images: [String] = []
    
    init(title: String, content: String, images: [String]) {
        self.title = title
        self.content = content
        self.images = images
    }
}

extension FeedObj {
    
    static func reallyLargeDataSource() -> [FeedObj] {
        
        var arr: [FeedObj] = []
        for _ in 0..<10 {
            let smallDatas = self.initialData()
            arr = arr + smallDatas
        }
        return arr
    }
    
    static func pullNewLargeDataSource() -> [FeedObj] {
        var arr: [FeedObj] = []
        for _ in 0..<30 {
            let smallDatas = self.ramdomNewData()
            arr = arr + smallDatas
        }
        return arr
    }
    
    private static func initialData() -> [FeedObj] {
        return [data_1, data_2, data_3, data_4, data_5, data_6, data_7, data_8, data_9, data_10]
    }
    
    private static func ramdomNewData() -> [FeedObj] {
        return [data_1, data_4, data_5, data_6, data_3, data_9, data_2]
    }
}

extension FeedObj: Equatable {
    public static func ==(lhs: FeedObj, rhs: FeedObj) -> Bool {
        return lhs.title == rhs.title
    }
}
