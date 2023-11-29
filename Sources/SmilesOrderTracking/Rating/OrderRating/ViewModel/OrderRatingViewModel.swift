//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 24/11/2023.
//

import Foundation
import SmilesUtilities
import Combine

final class OrderRatingViewModel {
    private var cancellables = Set<AnyCancellable>()
    private(set) var orderRatingUIModel: OrderRatingUIModel
    @Published private(set) var popupTitle: String?
    @Published private(set) var ratingTitle: String?
    @Published private(set) var ratingDescription: String?
    private var serviceHandler: OrderTrackingServiceHandler
    
    @Published private(set) var getOrderRatingResponse: GetOrderRatingResponse?
    @Published private(set) var rateOrderResponse: RateOrderResponse?
    @Published private(set) var ratingStarsData: [Rating]?
    private(set) var orderItems: [OrderItemDetail]?
    
    init(orderRatingUIModel: OrderRatingUIModel, serviceHandler: OrderTrackingServiceHandler) {
        self.orderRatingUIModel = orderRatingUIModel
        self.serviceHandler = serviceHandler
    }
    
    func getOrderRating() {
        serviceHandler.getOrderRating(ratingType: orderRatingUIModel.ratingType.asStringOrEmpty(), contentType: orderRatingUIModel.contentType.asStringOrEmpty(), isLiveTracking: orderRatingUIModel.isLiveTracking ?? false, orderId: orderRatingUIModel.orderId.asStringOrEmpty())
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                default:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.getOrderRatingResponse = response
                self.orderItems = response.orderItemDetails
                self.createPopupUI(with: response)
            }
        .store(in: &cancellables)
    }
    
    func submitRating() {
        serviceHandler.submitOrderRating(orderNumber: getOrderRatingResponse?.orderDetails?.orderNumber ?? "", orderId: orderRatingUIModel.orderId ?? "", restaurantName: getOrderRatingResponse?.orderDetails?.restaurantName ?? "", itemRatings: nil, orderRating: [], isAccrualPointsAllowed: getOrderRatingResponse?.isAccrualPointsAllowed ?? false, itemLevelRatingEnabled: getOrderRatingResponse?.itemLevelRatingEnabled ?? false, restaurantId: getOrderRatingResponse?.orderDetails?.restaurantID ?? "")
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                default:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.rateOrderResponse = response
            }
        .store(in: &cancellables)
    }
    
    private func createPopupUI(with getOrderRatingResponse: GetOrderRatingResponse) {
        if let orderRating = getOrderRatingResponse.orderRating {
            let rating = orderRating[0]
            ratingStarsData = rating.rating
            if rating.ratingType == "delivery" {
                popupTitle = rating.title
                let driverName = getOrderRatingResponse.orderDetails?.driverName ?? ""
                let deliveryTitle = rating.title?.replacingOccurrences(of: "{driver_name}", with: driverName)
                ratingTitle = deliveryTitle
                
                let deliveryTime = getOrderRatingResponse.orderDetails?.deliveredTime ?? ""
                let description = rating.description?.replacingOccurrences(of: "{driver_name}", with: driverName)
                let deliverDescription = description?.replacingOccurrences(of: "{delivered_time}", with: deliveryTime)
                ratingDescription = deliverDescription
            } else {
                popupTitle = getOrderRatingResponse.title
                let restaurantName = getOrderRatingResponse.orderDetails?.restaurantName ?? ""
                let deliveryTitle = rating.title?.replacingOccurrences(of: "{driver_name}", with: restaurantName)
                ratingTitle = deliveryTitle
            }
        }
    }
    
//    mutating private func createPopupUI() {
//        switch orderRatingUIModel.popupType {
//        case .rider:
//            popupTitle = OrderTrackingLocalization.rateYourDeliveryExperience.text
//            ratingTitle = String(format: OrderTrackingLocalization.howWouldYouRateRiderDelivery.text, orderRatingUIModel.riderName.asStringOrEmpty())
//            ratingDescription = String(format: OrderTrackingLocalization.riderDeliveredYourOrderInMins.text, orderRatingUIModel.riderName.asStringOrEmpty(), orderRatingUIModel.restaurantName.asStringOrEmpty(), orderRatingUIModel.deliveryTime.asStringOrEmpty())
//            
//        case .food:
//            popupTitle = OrderTrackingLocalization.rateYourFoodExperience.text
//            ratingTitle = String(format: OrderTrackingLocalization.howWouldYouRateRestaurantFood.text, orderRatingUIModel.restaurantName.asStringOrEmpty())
//        }
//    }
}
