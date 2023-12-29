//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 27/11/2023.
//

import Foundation

struct ChangedToPickupOrderConfig: OrderTrackable, CancelHeaderProtocol, GetSupportable {
    var response: OrderTrackingStatusResponse
    func buildConfig() -> GetSupportModel {
        let cells: [GetSupportCellType] = [
            .text(model: getTextModel()),
        ]
      
        return .init(header: getImageHeader(image: "Cancelled"), cells: cells + getSupportActions())
    }
    func build() -> OrderTrackingModel {
        let cells: [TrackingCellType] = [
            .text(model: getTextModel()),
            .orderCancelled(model: getOrderCancelledModel()),
            .orderActions(model: getOrderActionsModel())
        ]
      
        return .init(header: getCanceledHeader(), cells: cells)
    }
    
    private func getOrderActionsModel() -> OrderCancelledCollectionViewCell.ViewModel {
        var orderActions = OrderCancelledCollectionViewCell.ViewModel()
        let orderId = (response.orderDetails?.orderId).asIntOrEmpty()
        orderActions.orderId = "\(orderId)"
        orderActions.restaurantNumber = response.orderDetails?.restaurentNumber
        orderActions.restaurantId = (response.orderDetails?.restaurantId).asStringOrEmpty()
        return orderActions
    }
    
    private func getTextModel() -> TextCollectionViewCell.ViewModel {
        var viewModel = TextCollectionViewCell.ViewModel()
        viewModel.title = response.orderDetails?.title
        viewModel.type = .title
        return viewModel
    }
    
    private func getOrderCancelledModel() -> OrderCancelledTimerCollectionViewCell.ViewModel {
        var viewModel = OrderCancelledTimerCollectionViewCell.ViewModel()
        viewModel.buttonTitle = OrderTrackingLocalization.orderCancelledLikeToPickupOrder.text
        viewModel.title = (response.orderDetails?.orderDescription).asStringOrEmpty()
        let orderId = (response.orderDetails?.orderId).asIntOrEmpty()
        viewModel.orderId = "\(orderId)"
        viewModel.orderNumber = (response.orderDetails?.orderNumber).asStringOrEmpty()
        viewModel.timerCount = (response.orderDetails?.changeTypeTimer).asIntOrEmpty()
        viewModel.restaurantAddress = (response.orderDetails?.restaurantAddress).asStringOrEmpty()
        return viewModel
    }
}
