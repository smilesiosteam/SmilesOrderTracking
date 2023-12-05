//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 30/11/2023.
//

import Foundation

public protocol OrderTrackingNavigationProtocol: AnyObject {
    func navigateToOrderDetails(orderId: String, restaurantId: String)
    func openLiveChat(orderId: String, orderNumber: String)
    func navigationToOrderConfirmation(orderId: String, orderNumber: String)
    func navigateToSubscriptionPage(url: String)
    func navigateAvailableRestaurant()
    func navigateToVouchersRevamp(voucherCode: String)
    func navigateToLiveChatWebview(url: String)
}
