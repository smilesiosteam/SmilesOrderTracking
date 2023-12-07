//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 24/11/2023.
//

import Foundation
import SmilesUtilities
import Combine
import SmilesLoader

final class OrderRatingViewModel {
    private var cancellables = Set<AnyCancellable>()
    private(set) var orderRatingUIModel: OrderRatingUIModel
    private(set) var liveChatUseCase: LiveChatUseCaseProtocol
    @Published private(set) var popupTitle: String?
    @Published private(set) var ratingTitle: String?
    @Published private(set) var ratingDescription: String?
    private let serviceHandler = OrderTrackingServiceHandler()
    
    @Published private(set) var getOrderRatingResponse: GetOrderRatingResponse?
    @Published private(set) var rateOrderResponse: RateOrderResponse?
    @Published private(set) var ratingStarsData: [Rating]?
    @Published private(set) var orderItems: [OrderItemDetail]?
    @Published private(set) var shouldDismiss = false
    @Published private(set) var showErrorMessage: String?
    @Published private(set) var liveChatUrl: String?
    
    init(orderRatingUIModel: OrderRatingUIModel, liveChatUseCase: LiveChatUseCaseProtocol = LiveChatUseCase()) {
        self.orderRatingUIModel = orderRatingUIModel
        self.liveChatUseCase = liveChatUseCase
    }
    
    func getOrderRating() {
        SmilesLoader.show()
        serviceHandler.getOrderRating(ratingType: orderRatingUIModel.ratingType.asStringOrEmpty(), contentType: orderRatingUIModel.contentType.asStringOrEmpty(), isLiveTracking: orderRatingUIModel.isLiveTracking ?? false, orderId: orderRatingUIModel.orderId.asStringOrEmpty())
            .sink { [weak self] completion in
                guard let self else { return }
                SmilesLoader.dismiss()
                
                switch completion {
                case .failure(let error):
                    self.showErrorMessage = error.localizedDescription
                default:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.getOrderRatingResponse = response
                self.orderItems = response.orderItemDetails
                self.createPopupUI(with: response)
                SmilesLoader.dismiss()
            }
        .store(in: &cancellables)
    }
    
    func submitRating(with rating: OrderRatingModel) {
        SmilesLoader.show()
        serviceHandler.submitOrderRating(orderNumber: getOrderRatingResponse?.orderDetails?.orderNumber ?? "", orderId: orderRatingUIModel.orderId ?? "", restaurantName: getOrderRatingResponse?.orderDetails?.restaurantName ?? "", itemRatings: nil, orderRating: [rating], isAccrualPointsAllowed: getOrderRatingResponse?.isAccrualPointsAllowed ?? false, itemLevelRatingEnabled: getOrderRatingResponse?.itemLevelRatingEnabled ?? false, restaurantId: getOrderRatingResponse?.orderDetails?.restaurantID ?? "")
            .sink { [weak self] completion in
                guard let self else { return }
                SmilesLoader.dismiss()
                
                switch completion {
                case .failure(let error):
                    self.showErrorMessage = error.localizedDescription
                default:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.rateOrderResponse = response
                SmilesLoader.dismiss()
            }
        .store(in: &cancellables)
    }
    
    func getLiveChatUrl() {
        liveChatUseCase.statePublisher.sink { [weak self] state in
            guard let self else { return }
            switch state {
            case .showError(let message):
                SmilesLoader.dismiss()
                self.showErrorMessage = message
            case .navigateToLiveChatWebview(let url):
                SmilesLoader.dismiss()
                self.liveChatUrl = url
            }
        }.store(in: &cancellables)
        
        let orderDetails = getOrderRatingResponse?.orderDetails
        if let orderId = orderDetails?.orderId, let orderNumber = orderDetails?.orderNumber {
            SmilesLoader.show()
            liveChatUseCase.getLiveChatUrl(with: "\(orderId)", chatbotType: orderRatingUIModel.chatbotType.asStringOrEmpty(), orderNumber: orderNumber)
        }
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
}
