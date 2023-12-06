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
    
    var itemRatingUIModel: ItemRatingUIModel
    private(set) var popupTitle: String?
    @Published private(set) var rateOrderResponse: RateOrderResponse?
    var itemRatings = [ItemRatings]()
    var itemWiseRating = false
    var doneActionDismiss = false
    @Published private(set) var showErrorMessage: String?
    
    init(itemRatingUIModel: ItemRatingUIModel) {
        self.itemRatingUIModel = itemRatingUIModel
        super.init()
        
        configUI()
    }
    
    private func configUI() {
        popupTitle = itemRatingUIModel.ratingOrderResponse.ratingOrderResult?.title
        itemWiseRating = itemRatingUIModel.itemWiseRatingEnabled
    }
    
    func submitRating() {
        let serviceHandler = OrderTrackingServiceHandler()
        NotificationCenter.default.post(name: .ReloadOrderSummary, object: nil, userInfo: nil)
        
        SmilesLoader.show()
        let ratingOrderResponse = itemRatingUIModel.ratingOrderResponse
        serviceHandler.submitOrderRating(orderNumber: ratingOrderResponse.orderNumber.asStringOrEmpty(), orderId: ratingOrderResponse.orderId.asStringOrEmpty(), restaurantName: ratingOrderResponse.restaurantName.asStringOrEmpty(), itemRatings: itemRatings, orderRating: nil, isAccrualPointsAllowed: ratingOrderResponse.isAccrualPointsAllowed ?? false, itemLevelRatingEnabled: ratingOrderResponse.itemLevelRatingEnable ?? false, restaurantId: ratingOrderResponse.restaurantId)
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
}
