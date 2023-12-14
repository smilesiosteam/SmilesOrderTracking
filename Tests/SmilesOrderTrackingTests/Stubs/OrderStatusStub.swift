//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 14/12/2023.
//

import Foundation
import SmilesTests
@testable import SmilesOrderTracking

enum OrderStatusStub {
    static var getOrderStatusModel: OrderTrackingStatusResponse {
        let model: OrderTrackingStatusResponse? = readJsonFile("Order_Tracking_Model", bundle: .module)
        return model ?? .init()
    }
    
    
}
