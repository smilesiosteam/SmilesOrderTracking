//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 23/11/2023.
//

import Foundation
import SmilesBaseMainRequestManager

final class OrderCancelRequest: SmilesBaseMainRequest {
    // MARK: - Properties
    var orderId: String?
    var rejectionReason: String?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case userInfo
        case orderId
        case rejectionReason
    }
    
    // MARK: - Lifecycle
    init(orderId: String? = nil, rejectionReason: String? = nil) {
        super.init()
        self.orderId = orderId
        self.rejectionReason = rejectionReason
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.userInfo, forKey: .userInfo)
        try container.encodeIfPresent(self.orderId, forKey: .orderId)
        try container.encodeIfPresent(self.rejectionReason, forKey: .rejectionReason)
    }
}
