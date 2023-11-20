//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation
import NetworkingLayer

struct OrderTrackingStatusResponse: Codable {
    var orderDetails: OrderDetail?
    var orderItems: [OrderItem]?
    var orderItemDetails: [OrderItem]?
    var orderRating: [OrderRatings]?
    var orderTrackingDetails: [OrderTrackingDetail]?
    var orderTimeOut: Int?
    
    enum CodingKeys: String, CodingKey {
        case orderDetails
        case orderItems
        case orderItemDetails
        case orderTrackingDetails
        case orderRating = "orderRatings"
        case orderTimeOut
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderDetails = try values.decodeIfPresent(OrderDetail.self, forKey: .orderDetails)
        orderItems = try values.decodeIfPresent([OrderItem].self, forKey: .orderItems)
        orderItemDetails = try values.decodeIfPresent([OrderItem].self, forKey: .orderItemDetails)
        orderTrackingDetails = try values.decodeIfPresent([OrderTrackingDetail].self, forKey: .orderTrackingDetails)
        orderRating = try values.decodeIfPresent([OrderRatings].self, forKey: .orderRating)
        orderTimeOut = try values.decodeIfPresent(Int.self, forKey: .orderTimeOut)
    }
}
