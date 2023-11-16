//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 14/11/2023.
//

import Foundation
import SmilesUtilities

enum OrderTrackingLocalization {
    case support
    case callRestaurant
    case orderDetails
    case cancelOrder
    case pickUpYourOrderFrom
    case hasPickedUpYourOrder
    case restaurantCancelledOrder
    case viewAvailableRestaurants
    case pendingDeliveryConfirmation
    case yesTitle
    case noTitle
    case haveYouReceivedOrderFrom
    
    var text: String {
        switch self {
        case .support:
           return "Support"
        case .callRestaurant:
            return "Call restaurant".localizedString
        case .orderDetails:
            return "Order details".localizedString
        case .cancelOrder:
            return "Cancel order"
        case .pickUpYourOrderFrom:
            return "PickUpOrder".localizedString
        case .hasPickedUpYourOrder:
            return "has picked up your order"
        case .restaurantCancelledOrder:
            return "Sorry, the restaurant had to cancel your order. Would you like to order from another restaurant?"
        case .viewAvailableRestaurants:
            return "ViewAvailableRestaurant".localizedString
        case .pendingDeliveryConfirmation:
            return "Pending delivery confirmation"
        case .yesTitle:
            return "Yes".localizedString
        case .noTitle:
            return "No".localizedString
        case .haveYouReceivedOrderFrom:
            return "Have you received".localizedString
        }
    }
}
