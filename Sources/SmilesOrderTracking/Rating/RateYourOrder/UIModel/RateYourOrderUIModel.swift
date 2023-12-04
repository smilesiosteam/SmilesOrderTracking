//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 04/12/2023.
//

import Foundation

struct RateYourOrderUIModel {
    var ratingOrderResponse: GetOrderRatingResponse
    
    init(ratingOrderResponse: GetOrderRatingResponse) {
        self.ratingOrderResponse = ratingOrderResponse
    }
}
