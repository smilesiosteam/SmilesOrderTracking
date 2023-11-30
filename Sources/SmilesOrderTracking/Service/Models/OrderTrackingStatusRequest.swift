//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation
import SmilesBaseMainRequestManager

final class OrderTrackingStatusRequest: SmilesBaseMainRequest {
    // MARK: - Properties
    var orderId: String?
    var orderStatus: Int?
    var isChangeType: Bool?
    var isComingFromFirebase = false
    var isRevampedUI: Bool = true
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case orderId
        case orderStatus
        case isChangeType
        case isRevampedUI
    }
    
    // MARK: - Lifecycle
    init(orderId: String? = nil, orderStatus: Int? = nil, isChangeType: Bool? = nil) {
        super.init()
        self.orderId = orderId
        self.orderStatus = orderStatus
        self.isChangeType = isChangeType
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.orderId, forKey: .orderId)
        try container.encodeIfPresent(self.orderStatus, forKey: .orderStatus)
        try container.encodeIfPresent(self.isChangeType, forKey: .isChangeType)
        try container.encodeIfPresent(self.isRevampedUI, forKey: .isRevampedUI)
    }
}
