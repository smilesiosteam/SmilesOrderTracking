//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 29/11/2023.
//

import Foundation

struct OrderDetails: Codable {
    let orderNumber: String?
    let restaurantName: String?
    let orderType: String?
    let restaurantID: String?
    let driverName: String?
    let deliveredTime: String?
    let orderId: Int?

    enum CodingKeys: String, CodingKey {
        case orderNumber
        case restaurantName
        case orderType
        case restaurantID = "restaurantId"
        case driverName
        case deliveredTime
        case orderId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderNumber = try container.decodeIfPresent(String.self, forKey: .orderNumber)
        self.restaurantName = try container.decodeIfPresent(String.self, forKey: .restaurantName)
        self.orderType = try container.decodeIfPresent(String.self, forKey: .orderType)
        self.restaurantID = try container.decodeIfPresent(String.self, forKey: .restaurantID)
        self.driverName = try container.decodeIfPresent(String.self, forKey: .driverName)
        self.deliveredTime = try container.decodeIfPresent(String.self, forKey: .deliveredTime)
        self.orderId = try container.decodeIfPresent(Int.self, forKey: .orderId)
    }
}
