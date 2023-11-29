//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 28/11/2023.
//

import Foundation

struct RateOrderResponse: Codable {
    // MARK: - Properties
    var ratingOrderResult: RateOrderResult?
    var isAccrualPointsAllowed: Bool?
    var itemLevelRatingEnable: Bool?
    var restaurantName: String?
    var restaurantId: String?
    var orderNumber: String?
    var orderId: String?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case ratingOrderResult = "result"
        case isAccrualPointsAllowed = "isAccuralPointsAllowed"
        case itemLevelRatingEnable = "itemLevelRatingEnabled"
        case restaurantName
        case restaurantId
        case orderId
        case orderNumber
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ratingOrderResult = try container.decodeIfPresent(RateOrderResult.self, forKey: .ratingOrderResult)
        self.isAccrualPointsAllowed = try container.decodeIfPresent(Bool.self, forKey: .isAccrualPointsAllowed)
        self.itemLevelRatingEnable = try container.decodeIfPresent(Bool.self, forKey: .itemLevelRatingEnable)
        self.restaurantName = try container.decodeIfPresent(String.self, forKey: .restaurantName)
        self.restaurantId = try container.decodeIfPresent(String.self, forKey: .restaurantId)
        self.orderId = try container.decodeIfPresent(String.self, forKey: .orderId)
        self.orderNumber = try container.decodeIfPresent(String.self, forKey: .orderNumber)
    }
}
