//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 18/12/2023.
//

import Foundation
@testable import SmilesOrderTracking

final class OrderTrackingNavigationSpy: OrderTrackingNavigationProtocol {
    
    // MARK: - Properties
    var isLiveLocationCalled = false
    var liveTrackingId = ""
    
    // MARK: - Spys
    func navigateToOrderDetails(orderId: String, restaurantId: String) {
        
    }
    
    func openLiveChat(orderId: String, orderNumber: String) {
        
    }
    
    func navigationToOrderConfirmation(orderId: String, orderNumber: String) {
        
    }
    
    func navigateToSubscriptionPage(url: String) {
        
    }
    
    func navigateAvailableRestaurant() {
        
    }
    
    func navigateToVouchersRevamp(voucherCode: String) {
        
    }
    
    func navigateToLiveChatWebview(url: String) {
        
    }
    
    func navigateToFAQs() {
        
    }
    
    func popToViewRestaurantDetailVC() {
        
    }
    
    func closeTracking() {
        
    }
    
    func liveLocation(liveTrackingId: String) {
        isLiveLocationCalled.toggle()
        self.liveTrackingId = liveTrackingId
    }
    
    func fireSuccessfulOrderCompletionEvent() {
        
    }
    
    func fireOrderTrackingEvent() {
        
    }
    
    func navigateToOfferDetails(offerId: String, offerType: String) {
        
    }
}
