//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 05/12/2023.
//

import Foundation

public enum LiveTrackingState {
    case orderStatusDidChange(orderId: String, orderNumber: String, orderStatus: OrderTrackingType, comingFromFirebase: Bool)
    case liveLocationDidUpdate(latitude: Double, longitude: Double)
}
