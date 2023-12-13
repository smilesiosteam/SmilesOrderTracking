//
//  File.swift
//
//
//  Created by Muhammad Shayan Zahid on 29/11/2023.
//

import Foundation

struct GetOrderRatingResponse: Codable {
    // MARK: - Properties
   var title: String?
   var orderRating: [OrderRating]?
   var orderDetails: OrderDetails?
   var orderItemDetails: [OrderItemDetail]?
   var isAccrualPointsAllowed: Bool?
   var itemLevelRatingEnabled: Bool?
   var ratingStatus: Bool?
    
    enum CodingKeys: String, CodingKey {
        case title
        case orderRating
        case orderDetails
        case orderItemDetails
        case isAccrualPointsAllowed = "isAccuralPointsAllowed"
        case itemLevelRatingEnabled
        case ratingStatus
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.orderRating = try container.decodeIfPresent([OrderRating].self, forKey: .orderRating)
        self.orderDetails = try container.decodeIfPresent(OrderDetails.self, forKey: .orderDetails)
        self.orderItemDetails = try container.decodeIfPresent([OrderItemDetail].self, forKey: .orderItemDetails)
        self.isAccrualPointsAllowed = try container.decodeIfPresent(Bool.self, forKey: .isAccrualPointsAllowed)
        self.itemLevelRatingEnabled = try container.decodeIfPresent(Bool.self, forKey: .itemLevelRatingEnabled)
        self.ratingStatus = try container.decodeIfPresent(Bool.self, forKey: .ratingStatus)
    }
    init(){}
}
