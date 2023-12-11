//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 24/11/2023.
//

import Foundation
import SmilesUtilities
import SmilesBaseMainRequestManager

final class RateOrderRequest: SmilesBaseMainRequest {
    // MARK: - Properties
    var orderId: String?
    var orderNumber: String?
    var restaurantName: String?
    var orderRatings: [OrderRatingModel]?
    var itemRatings: [ItemRatings]?
    var isAccuralPointsAllowed: Bool?
    var itemLevelRatingEnabled: Bool?
    var restaurantId: String?
    var userFeedback: String?
    var isRevampedUI: Bool?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey{
        case orderId
        case orderNumber
        case restaurantName
        case orderRatings
        case itemRatings
        case isAccuralPointsAllowed
        case itemLevelRatingEnabled
        case restaurantId
        case userFeedback
        case isRevampedUI
    }
    
    // MARK: - Lifecycle
    init(orderId: String? = nil, orderNumber: String? = nil, restaurantName: String? = nil, orderRatings: [OrderRatingModel]? = nil, itemRatings: [ItemRatings]? = nil, isAccuralPointsAllowed: Bool? = nil, itemLevelRatingEnabled: Bool? = nil, restaurantId: String? = nil, userFeedback: String? = nil, isRevampedUI: Bool? = true) {
        super.init()
        self.orderId = orderId
        self.orderNumber = orderNumber
        self.restaurantName = restaurantName
        self.orderRatings = orderRatings
        self.itemRatings = itemRatings
        self.isAccuralPointsAllowed = isAccuralPointsAllowed
        self.itemLevelRatingEnabled = itemLevelRatingEnabled
        self.restaurantId = restaurantId
        self.userFeedback = userFeedback
        self.isRevampedUI = isRevampedUI
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.orderId, forKey: .orderId)
        try container.encodeIfPresent(self.orderNumber, forKey: .orderNumber)
        try container.encodeIfPresent(self.restaurantName, forKey: .restaurantName)
        try container.encodeIfPresent(self.orderRatings, forKey: .orderRatings)
        try container.encodeIfPresent(self.itemRatings, forKey: .itemRatings)
        try container.encodeIfPresent(self.isAccuralPointsAllowed, forKey: .isAccuralPointsAllowed)
        try container.encodeIfPresent(self.itemLevelRatingEnabled, forKey: .itemLevelRatingEnabled)
        try container.encodeIfPresent(self.restaurantId, forKey: .restaurantId)
        try container.encodeIfPresent(self.userFeedback, forKey: .userFeedback)
        try container.encodeIfPresent(self.isRevampedUI, forKey: .isRevampedUI)
    }
}
