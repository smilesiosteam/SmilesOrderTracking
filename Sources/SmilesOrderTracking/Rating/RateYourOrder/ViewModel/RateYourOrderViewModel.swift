//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 04/12/2023.
//

import Foundation
import Combine
import SmilesLoader

final public class RateYourOrderViewModel: NSObject {
    private var cancellables = Set<AnyCancellable>()
    
    var rateYourOrderUIModel: RateYourOrderUIModel
    private(set) var liveChatUseCase: LiveChatUseCaseProtocol
    private(set) var popupTitle: String?
    @Published private(set) var rateOrderResponse: RateOrderResponse?
    var itemRatings = [ItemRatings]()
    @Published private(set) var showErrorMessage: String?
    var orderRatings = [OrderRating]()
    var orderRatingsItems = [OrderRating]()
    var isAnyRatingGiven = false
    var lastHighestDeliveryValue = 0
    var lastHighestFoodValue = 0
    var parityCheckNumber = 0
    var userFeedbackText: String?
    var orderRatingModels = [OrderRatingModel]()
    @Published private(set) var liveChatUrl: String?
    
    init(rateYourOrderUIModel: RateYourOrderUIModel, liveChatUseCase: LiveChatUseCaseProtocol = LiveChatUseCase()) {
        self.rateYourOrderUIModel = rateYourOrderUIModel
        self.liveChatUseCase = liveChatUseCase
        super.init()
        
        configUI()
    }
    
    private func configUI() {
        popupTitle = rateYourOrderUIModel.ratingOrderResponse.title
    }
    
    func submitRating() {
        let serviceHandler = OrderTrackingServiceHandler(repository: TrackOrderConfigurator.repository)
        
        SmilesLoader.show()
        let ratingOrderResponse = rateYourOrderUIModel.ratingOrderResponse
        serviceHandler.submitOrderRating(orderNumber: ratingOrderResponse.orderDetails?.orderNumber ?? "", orderId: "\(ratingOrderResponse.orderDetails?.orderId ?? 0)", restaurantName: ratingOrderResponse.orderDetails?.restaurantName ?? "", itemRatings: nil, orderRating: orderRatingModels, isAccrualPointsAllowed: ratingOrderResponse.isAccrualPointsAllowed ?? false, itemLevelRatingEnabled: ratingOrderResponse.itemLevelRatingEnabled ?? false, restaurantId: ratingOrderResponse.orderDetails?.restaurantID ?? "", userFeedback: userFeedbackText)
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
        SmilesLoader.show()
        
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
        
        let orderDetails = rateYourOrderUIModel.ratingOrderResponse.orderDetails
        if let orderId = orderDetails?.orderId, let orderNumber = orderDetails?.orderNumber {
            liveChatUseCase.getLiveChatUrl(with: "\(orderId)", chatbotType: rateYourOrderUIModel.chatbotType, orderNumber: orderNumber)
        }
    }
}
