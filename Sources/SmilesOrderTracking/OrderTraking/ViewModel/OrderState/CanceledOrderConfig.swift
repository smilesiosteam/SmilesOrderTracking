//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 27/11/2023.
//

import Foundation

struct CanceledOrderConfig: OrderTrackable {
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {
        let cells: [TrackingCellType] = [
            .text(model: getTextModel()),
            .orderCancelled(model: getOrderCancelledModel()),
            .cashVoucher(model: .init()),
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
        viewModel.buttonTitle = OrderTrackingLocalization.restaurantCanceledButtonTitle.text
        viewModel.title = OrderTrackingLocalization.restaurantCanceledTitle.text
        return viewModel
    }
}
