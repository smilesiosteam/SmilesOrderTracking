//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 04/12/2023.
//

import Foundation

struct RateYourOrderUIModel {
    var ratingOrderResponse: GetOrderRatingResponse
    public var chatbotType: String
    
    init(ratingOrderResponse: GetOrderRatingResponse, chatbotType: String) {
        self.ratingOrderResponse = ratingOrderResponse
        self.chatbotType = chatbotType
    }
}
