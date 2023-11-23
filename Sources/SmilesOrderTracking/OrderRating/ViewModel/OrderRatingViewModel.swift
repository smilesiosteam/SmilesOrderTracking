//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 24/11/2023.
//

import Foundation

public struct OrderRatingViewModel {
    public var orderRatingUIModel: OrderRatingUIModel
    private(set) var popupTitle: String?
    private(set) var ratingTitle: String?
    private(set) var ratingDescription: String?
    
    public init(orderRatingUIModel: OrderRatingUIModel) {
        self.orderRatingUIModel = orderRatingUIModel
        createPopupUI()
    }
    
    mutating private func createPopupUI() {
        switch orderRatingUIModel.popupType {
        case .rider:
            popupTitle = OrderTrackingLocalization.rateYourDeliveryExperience.text
            ratingTitle = String(format: OrderTrackingLocalization.howWouldYouRateRiderDelivery.text, orderRatingUIModel.riderName.asStringOrEmpty())
            ratingDescription = String(format: OrderTrackingLocalization.riderDeliveredYourOrderInMins.text, orderRatingUIModel.riderName.asStringOrEmpty(), orderRatingUIModel.restaurantName.asStringOrEmpty(), orderRatingUIModel.deliveryTime.asStringOrEmpty())
            
        case .food:
            popupTitle = OrderTrackingLocalization.rateYourFoodExperience.text
            ratingTitle = String(format: OrderTrackingLocalization.howWouldYouRateRestaurantFood.text, orderRatingUIModel.restaurantName.asStringOrEmpty())
        }
    }
}
