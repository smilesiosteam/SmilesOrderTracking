//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 23/11/2023.
//

import Foundation

struct OrderChangeTypeResponse: Codable {
    // MARK: - Properties
    var isChangeType: Bool?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case isChangeType
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isChangeType = try container.decodeIfPresent(Bool.self, forKey: .isChangeType)
    }
    
    init() {}
}
