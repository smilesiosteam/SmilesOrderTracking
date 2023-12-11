//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 29/11/2023.
//

import Foundation
import SmilesUtilities
import SmilesBaseMainRequestManager

final class GetOrderRatingRequest: SmilesBaseMainRequest {
    // MARK: - Properties
    var ratingType: String?
    var contentType: String?
    var isLiveTracking: Bool?
    var orderId: String?
    var isRevampedUI: Bool?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case ratingType
        case contentType
        case isLiveTracking
        case orderId
        case isRevampedUI
    }
    
    // MARK: - Lifecycle
    init(ratingType: String? = nil, contentType: String? = nil, isLiveTracking: Bool? = false, orderId: String? = nil, isRevampedUI: Bool? = true) {
        super.init()
        self.ratingType = ratingType
        self.contentType = contentType
        self.isLiveTracking = isLiveTracking
        self.orderId = orderId
        self.isRevampedUI = isRevampedUI
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.ratingType, forKey: .ratingType)
        try container.encodeIfPresent(self.contentType, forKey: .contentType)
        try container.encodeIfPresent(self.isLiveTracking, forKey: .isLiveTracking)
        try container.encodeIfPresent(self.orderId, forKey: .orderId)
        try container.encodeIfPresent(self.isRevampedUI, forKey: .isRevampedUI)
    }
}
