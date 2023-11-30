//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation

struct OrderTrackingDetail: Codable {
    var orderDetails: OrderDetail?
    var orderItems: [OrderItem]?
    var orderRating: [OrderRatings]?

    enum CodingKeys: String, CodingKey {
        case orderDetails = "orderDetails"
        case orderItems = "orderItems"
        case orderRating = "orderRatings"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderDetails = try values.decodeIfPresent(OrderDetail.self, forKey: .orderDetails)
        orderItems = try values.decodeIfPresent([OrderItem].self, forKey: .orderItems)
        orderRating = try values.decodeIfPresent([OrderRatings].self, forKey: .orderRating)
    }
}
