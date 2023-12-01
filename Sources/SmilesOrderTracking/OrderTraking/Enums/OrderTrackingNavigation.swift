//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 30/11/2023.
//

import Foundation
public enum OrderTrackingNavigation {
    case orderDetails(orderId: String, restaurantId: String)
}


public protocol OrderTrackingNavigationProtocol: AnyObject {
    func navigateToOrderDetails(orderId: String, restaurantId: String)
}
