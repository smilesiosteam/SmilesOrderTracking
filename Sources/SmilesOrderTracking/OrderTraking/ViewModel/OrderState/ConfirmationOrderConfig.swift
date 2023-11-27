//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 27/11/2023.
//

import Foundation

struct ConfirmationOrderConfig: OrderTrackable {
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .completed
        progressBar.hideTimeLabel = true
        
        var location = orderLocation
        location.type = .details
        
        var cells: [TrackingCellType] = [
            .progressBar(model: progressBar),
            .text(model: .init(title: orderText)),
            .location(model: location),
            .confirmation(model: getConfirmationModel())
        ]
        
        if let orderSubscription {
            cells.append(.subscription(model: orderSubscription))
        }
        
        let header: TrackingHeaderType = .map(model: orderMapModel)
        return .init(header: header, cells: cells)
    }
    
    private func getConfirmationModel() -> OrderConfirmationCollectionViewCell.ViewModel {
        var viewModel = OrderConfirmationCollectionViewCell.ViewModel()
        
        guard let restaurantName = response.orderDetails?.restaurantName else {
            return .init()
        }

        let orderType = response.orderDetails?.orderType?.lowercased() ?? ""
       
        let questionFormat = (orderType == OrderTrackingCellType.delivery.text.lowercased()) ? OrderTrackingLocalization.didReceivedOrder.text : OrderTrackingLocalization.didPickedOrder.text
        let question = String(format: questionFormat, restaurantName)
        
        viewModel.question = question
        viewModel.orderId = response.orderDetails?.orderId ?? 0
        return viewModel
    }

}
