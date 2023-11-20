//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 20/11/2023.
//

import Foundation

struct OrderTrackingResponseModel: Codable {
    let extTransactionID: String?
    let orderDetails: OrderDetails?
    let orderItems: [OrderItem]?

    enum CodingKeys: String, CodingKey {
        case extTransactionID = "extTransactionId"
        case orderDetails, orderItems
    }
}

// MARK: - OrderDetails
struct OrderDetails: Codable {
    let orderStatus: Int?
    let title, orderDescription, orderNumber, restaurantName: String?
    let deliveryRegion, recipient, totalAmount, deliveryCharges: String?
    let discount: String?
    let promoCodeDiscount, grandTotal: Int?
    let vatPrice: Double?
    let totalSaving: Int?
    let orderTime, deliveryTime, deliveryTimeRange, deliveryTimeRangeText: String?
    let deliveryTimeRangeV2, pickupTime, restaurantAddress, phone: String?
    let latitude, longitude, restaurentNumber, estimateTime: String?
    let deliveryAdrress: String?
    let orderTimeOut: Int?
    let isCancelationAllowed: Bool?
    let orderType: String?
    let determineStatus: Bool?
    let earnPoints: Int?
    let addressTitle: String?
    let reOrder, liveTracking: Bool?
    let orderID: Int?
    let imageURL, iconURL: String?
    let deliveryLatitude, deliveryLongitude, trackingType, paymentType: String?
    let paidAedAmount: String?
    let isFirstOrder: Bool?
    let statusText: String?
    let inlineItemIncluded, virtualRestaurantIncluded: Bool?
    let inlineItemTotal: Int?
    let restaurantID: String?
    let isDeliveryFree: Bool?
    let deliveryTip: Int?
    let isLiveChatEnable: Bool?
    let deliveryBy: String?
    let subscriptionBanner: SubscriptionBanner?
    enum CodingKeys: String, CodingKey {
        case orderStatus, title, orderDescription, orderNumber, restaurantName, deliveryRegion, recipient, totalAmount, deliveryCharges, discount, promoCodeDiscount, grandTotal, vatPrice, totalSaving, orderTime, deliveryTime, deliveryTimeRange, deliveryTimeRangeText, deliveryTimeRangeV2, pickupTime, restaurantAddress, phone, latitude, longitude, restaurentNumber, estimateTime, deliveryAdrress, orderTimeOut, isCancelationAllowed, orderType, determineStatus, earnPoints, addressTitle, reOrder, liveTracking, subscriptionBanner
        case orderID = "orderId"
        case imageURL = "imageUrl"
        case iconURL = "iconUrl"
        case deliveryLatitude, deliveryLongitude, trackingType, paymentType, paidAedAmount, isFirstOrder, statusText, inlineItemIncluded, virtualRestaurantIncluded, inlineItemTotal
        case restaurantID = "restaurantId"
        case isDeliveryFree, deliveryTip, isLiveChatEnable, deliveryBy
    }
}

// MARK: - OrderItem
struct OrderItem: Codable {
    let quantity: Int?
    let choicesName: [String]?
    let discountPrice, actualChoicePoints: Int?
    let isVeg, isEggIncluded: Bool?
    let itemName: String?
    let price: Int?
    let inlineItemIncluded: Bool?
}

struct SubscriptionBanner: Codable {
    let subscriptionTitle: String?
    let subscriptionIcon: String?
    let redirectionURL: String?

    enum CodingKeys: String, CodingKey {
        case subscriptionTitle, subscriptionIcon
        case redirectionURL = "redirectionUrl"
    }
}
