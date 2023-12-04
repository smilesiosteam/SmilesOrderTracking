//
//  File.swift
//
//
//  Created by Ahmed Naguib on 27/11/2023.
//

import Foundation
import UIKit

struct ConfirmationOrderConfig: OrderTrackable {
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .fourth
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
        
        return .init(header: getHeader(), cells: cells)
    }
    
    private func getConfirmationModel() -> OrderConfirmationCollectionViewCell.ViewModel {
        var viewModel = OrderConfirmationCollectionViewCell.ViewModel()
        
        guard let restaurantName = response.orderDetails?.restaurantName else {
            return .init()
        }
        
        let orderType = response.orderDetails?.orderType?.lowercased() ?? ""
        
        let questionFormat = (orderType == OrderTrackingCellType.delivery.rawValue.lowercased()) ? OrderTrackingLocalization.didReceivedOrder.text : OrderTrackingLocalization.didPickedOrder.text
        let question = String(format: questionFormat, restaurantName)
        
        viewModel.question = question
        let orderId = response.orderDetails?.orderId ?? 0
        viewModel.orderId = "\(orderId)"
        viewModel.orderNumber = response.orderDetails?.orderNumber ?? ""
        return viewModel
    }
    
    private func getHeader() -> TrackingHeaderType{
        let color = UIColor.black.withAlphaComponent(0.8)
        let image = "Confirmation"
        let header: TrackingHeaderType = .image(model: .init(isShowSupportHeader: true, type: .image(imageName: image, backgroundColor: color)))
        return header
    }
}
