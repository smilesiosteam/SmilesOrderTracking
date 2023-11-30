//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 23/11/2023.
//

import Foundation
import SmilesLocationHandler

final class OrderCancelRequest: Codable {
    // MARK: - Properties
    var userInfo: SmilesUserInfo?
    var orderId: String?
    var rejectionReason: String?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case userInfo
        case orderId
        case rejectionReason
    }
    
    // MARK: - Lifecycle
    init(userInfo: SmilesUserInfo? = nil, orderId: String? = nil, rejectionReason: String? = nil) {
        self.userInfo = userInfo
        self.orderId = orderId
        self.rejectionReason = rejectionReason
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.userInfo, forKey: .userInfo)
        try container.encodeIfPresent(self.orderId, forKey: .orderId)
        try container.encodeIfPresent(self.rejectionReason, forKey: .rejectionReason)
    }
}
