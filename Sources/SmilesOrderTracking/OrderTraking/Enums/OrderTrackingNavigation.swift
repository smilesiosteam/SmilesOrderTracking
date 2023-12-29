//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 30/11/2023.
//

import Foundation

public protocol OrderTrackingLiveProtocol: AnyObject {
    func closeTracking()
    func liveLocation(liveTrackingId: String)
    func fireSuccessfulOrderCompletionEvent()
    func fireOrderTrackingEvent()
}

public protocol OrderTrackingNavigationProtocol: OrderTrackingLiveProtocol {
    func navigateToOrderDetails(orderId: String, restaurantId: String)
    func openLiveChat(orderId: String, orderNumber: String)
    func navigationToOrderConfirmation(orderId: String, orderNumber: String)
    func navigateToSubscriptionPage(url: String)
    func navigateAvailableRestaurant()
    func navigateToVouchersRevamp(voucherCode: String)
    func navigateToOfferDetails(offerId: String, offerType: String)
    func navigateToLiveChatWebview(url: String)
    func navigateToFAQs()
    func popToViewRestaurantDetailVC()
}
