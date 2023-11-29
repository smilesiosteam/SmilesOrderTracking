//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 29/11/2023.
//

import Foundation

struct ItemRatingUIModel {
    var itemWiseRatingEnabled: Bool
    var isAccrualPointsAllowed: Bool
    var orderItems: [OrderItemDetail]
    var ratingOrderResponse: RateOrderResponse
    
    init(itemWiseRatingEnabled: Bool, isAccrualPointsAllowed: Bool, orderItems: [OrderItemDetail], ratingOrderResponse: RateOrderResponse) {
        self.itemWiseRatingEnabled = itemWiseRatingEnabled
        self.isAccrualPointsAllowed = isAccrualPointsAllowed
        self.orderItems = orderItems
        self.ratingOrderResponse = ratingOrderResponse
    }
}
