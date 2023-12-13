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
    private var orderRatingUIModel: OrderRatingUIModel
    private var liveChatUseCase: LiveChatUseCaseProtocol
    private var stateSubject: PassthroughSubject<State, Never> = .init()
    var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    private let serviceHandler = OrderTrackingServiceHandler(repository: TrackOrderConfigurator.repository)
    private var getOrderRatingResponse: GetOrderRatingResponse?
    
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
                    self.stateSubject.send(.showError(message: error.localizedDescription))
                default:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.getOrderRatingResponse = response
                self.stateSubject.send(.getOrderRatingResponse(response: response))
                self.stateSubject.send(.orderItems(items: response.orderItemDetails))
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
                    self.stateSubject.send(.showError(message: error.localizedDescription))
                default:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.stateSubject.send(.rateOrderResponse(response: response))
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
                self.stateSubject.send(.showError(message: message))
            case .navigateToLiveChatWebview(let url):
                SmilesLoader.dismiss()
                self.stateSubject.send(.liveChatUrl(url: url))
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
            stateSubject.send(.ratingStarsData(data: rating.rating))
            if rating.ratingType == "delivery" {
                stateSubject.send(.popupTitle(text: getOrderRatingResponse.title ?? ""))
                let driverName = getOrderRatingResponse.orderDetails?.driverName ?? ""
                let deliveryTitle = rating.title?.replacingOccurrences(of: "{driver_name}", with: driverName)
                stateSubject.send(.ratingTitle(text: deliveryTitle ?? ""))
                
                let deliveryTime = getOrderRatingResponse.orderDetails?.deliveredTime ?? ""
                let description = rating.description?.replacingOccurrences(of: "{driver_name}", with: driverName)
                let deliverDescription = description?.replacingOccurrences(of: "{delivered_time}", with: deliveryTime)
                stateSubject.send(.ratingDescription(text: deliverDescription ?? ""))
            } else {
                stateSubject.send(.popupTitle(text: getOrderRatingResponse.title ?? ""))
                let restaurantName = getOrderRatingResponse.orderDetails?.restaurantName ?? ""
                let deliveryTitle = rating.title?.replacingOccurrences(of: "{driver_name}", with: restaurantName)
                stateSubject.send(.ratingTitle(text: deliveryTitle ?? ""))
            }
        }
    }
}

extension OrderRatingViewModel {
    enum State {
        case popupTitle(text: String)
        case ratingTitle(text: String)
        case ratingDescription(text: String)
        case showError(message: String)
        case getOrderRatingResponse(response: GetOrderRatingResponse?)
        case rateOrderResponse(response: RateOrderResponse?)
        case ratingStarsData(data: [Rating]?)
        case orderItems(items: [OrderItemDetail]?)
        case liveChatUrl(url: String?)
    }
}
