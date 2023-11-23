//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 24/11/2023.
//

import Foundation

public struct OrderRatingUIModel {
    public enum PopupType {
        case rider
        case food
    }
    
    public var popupType: PopupType
    public var riderName: String?
    public var restaurantName: String?
    public var deliveryTime: String?
    
    public init(popupType: PopupType, riderName: String? = nil, restaurantName: String? = nil, deliveryTime: String? = nil) {
        self.popupType = popupType
        self.riderName = riderName
        self.restaurantName = restaurantName
        self.deliveryTime = deliveryTime
    }
}
