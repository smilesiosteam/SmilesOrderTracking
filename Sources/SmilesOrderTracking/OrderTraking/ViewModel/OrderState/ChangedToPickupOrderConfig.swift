//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 27/11/2023.
//

import Foundation

struct ChangedToPickupOrderConfig: OrderTrackable {
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {
        let cells: [TrackingCellType] = [
            .text(model: getTextModel()),
            .orderCancelled(model: getOrderCancelledModel()),
            .orderActions(model: getOrderActionsModel())
        ]
        let header: TrackingHeaderType = .image(model: .init())
        return .init(header: header, cells: cells)
    }
    
    private func getOrderActionsModel() -> OrderCancelledCollectionViewCell.ViewModel {
        var orderActions = OrderCancelledCollectionViewCell.ViewModel()
        orderActions.orderId = response.orderDetails?.orderId
        orderActions.restaurantNumber = response.orderDetails?.restaurentNumber
        return orderActions
    }
    
    private func getTextModel() -> TextCollectionViewCell.ViewModel {
        var viewModel = TextCollectionViewCell.ViewModel()
        viewModel.title = orderText
        viewModel.type = .title
        return viewModel
    }
    
    private func getOrderCancelledModel() -> OrderCancelledTimerCollectionViewCell.ViewModel {
        var viewModel = OrderCancelledTimerCollectionViewCell.ViewModel()
        viewModel.buttonTitle = OrderTrackingLocalization.orderCancelledLikeToPickupOrder.text
        viewModel.title = OrderTrackingLocalization.orderCancelledBadWeather.text
        let timeOut = response.orderDetails?.orderTimeOut ?? 0
        viewModel.timerCount = timeOut * 60
        return viewModel
    }
}
