//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 28/11/2023.
//

import UIKit
import Combine
import SmilesLoader
import SmilesUtilities

final public class ItemRatingViewModel: NSObject {
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var serviceHandler: OrderTrackingServiceHandler
    private(set) var itemRatingUIModel: ItemRatingUIModel
    private(set) var popupTitle: String?
    @Published private(set) var rateOrderResponse: RateOrderResponse?
    var itemRatings = [ItemRatings]()
    var itemWiseRating = false
    var doneActionDismiss = false
    
    init(itemRatingUIModel: ItemRatingUIModel, serviceHandler: OrderTrackingServiceHandler) {
        self.itemRatingUIModel = itemRatingUIModel
        self.serviceHandler = serviceHandler
        super.init()
        
        configUI()
    }
    
    private func configUI() {
        popupTitle = itemRatingUIModel.ratingOrderResponse.ratingOrderResult?.title
    }
    
    func submitRating() {
        NotificationCenter.default.post(name: .ReloadOrderSummary, object: nil, userInfo: nil)
        
        SmilesLoader.show()
        let ratingOrderResponse = itemRatingUIModel.ratingOrderResponse
        serviceHandler.submitOrderRating(orderNumber: ratingOrderResponse.orderNumber.asStringOrEmpty(), orderId: ratingOrderResponse.orderId.asStringOrEmpty(), restaurantName: ratingOrderResponse.restaurantName.asStringOrEmpty(), itemRatings: itemRatings, orderRating: nil, isAccrualPointsAllowed: ratingOrderResponse.isAccrualPointsAllowed ?? false, itemLevelRatingEnabled: ratingOrderResponse.itemLevelRatingEnable ?? false, restaurantId: ratingOrderResponse.restaurantId)
            .sink { completion in
                SmilesLoader.dismiss()
                switch completion {
                case .failure(let error):
                    print(error)
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
}
