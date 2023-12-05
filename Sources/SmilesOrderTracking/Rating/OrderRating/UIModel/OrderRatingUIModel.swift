//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 24/11/2023.
//

import Foundation

public struct OrderRatingUIModel {
    public var ratingType: String?
    public var contentType: String?
    public var isLiveTracking: Bool?
    public var orderId: String?
    public var chatbotType: String?
    
    public init(ratingType: String? = nil, contentType: String? = nil, isLiveTracking: Bool? = false, orderId: String? = nil, chatbotType: String? = nil) {
        self.ratingType = ratingType
        self.contentType = contentType
        self.isLiveTracking = isLiveTracking
        self.orderId = orderId
        self.chatbotType = chatbotType
    }
}
