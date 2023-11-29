//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 28/11/2023.
//

import UIKit

final public class ItemRatingViewModel: NSObject {
    private(set) var itemRatingUIModel: ItemRatingUIModel
//    var orderId: String
//    var itemsToRate: [ItemRatingViewController.MockItem]
    
//    init(orderId: String, itemsToRate: [ItemRatingViewController.MockItem]) {
//        self.orderId = orderId
//        self.itemsToRate = itemsToRate
//    }
    
    init(itemRatingUIModel: ItemRatingUIModel) {
        self.itemRatingUIModel = itemRatingUIModel
    }
}
