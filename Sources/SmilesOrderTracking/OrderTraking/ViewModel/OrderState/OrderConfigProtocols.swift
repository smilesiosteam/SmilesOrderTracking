//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 28/11/2023.
//

import Foundation
import UIKit

protocol CanceledOrderConfigProtocol: OrderTrackable, CancelHeaderProtocol { }

extension CanceledOrderConfigProtocol {
    func getOrderActionsModel() -> OrderCancelledCollectionViewCell.ViewModel {
        var orderActions = OrderCancelledCollectionViewCell.ViewModel()
        let orderId = response.orderDetails?.orderId ?? 0
        orderActions.orderId = "\(orderId)"
        orderActions.restaurantId = response.orderDetails?.restaurantId ?? ""
        orderActions.restaurantNumber = response.orderDetails?.restaurentNumber
        return orderActions
    }
    
    func getTextModel() -> TextCollectionViewCell.ViewModel {
        var viewModel = TextCollectionViewCell.ViewModel()
        viewModel.title = orderText
        viewModel.type = .title
        return viewModel
    }
    
    func getOrderCancelledModel(buttonTitle: String) -> OrderCancelledTimerCollectionViewCell.ViewModel {
        var viewModel = OrderCancelledTimerCollectionViewCell.ViewModel()
        viewModel.buttonTitle = buttonTitle
        let orderId = response.orderDetails?.orderId ?? 0
        viewModel.orderId = "\(orderId)"
        viewModel.orderNumber = response.orderDetails?.orderNumber ?? ""
        viewModel.title = response.orderDetails?.orderDescription ?? ""
        viewModel.restaurantAddress = response.orderDetails?.restaurantAddress ?? ""
        return viewModel
    }
}

protocol CancelHeaderProtocol: OrderTrackable { }

extension CancelHeaderProtocol {
    func getCanceledHeader() -> TrackingHeaderType {
        let color = UIColor(red: 74, green: 9, blue: 0)
        let image = "Cancelled"
        var viewModel = ImageHeaderCollectionViewCell.ViewModel(type: .image(imageName: image, backgroundColor: color))
        viewModel.isShowSupportHeader = true
        let header: TrackingHeaderType = .image(model: viewModel)
        return header
    }
}

protocol AnimationHeaderProtocol: OrderTrackable { }

extension AnimationHeaderProtocol {
    func getAnimationHeader(isShowButtons: Bool) -> TrackingHeaderType {
        let url = URL(string: response.orderDetails?.largeImageAnimationUrl ?? "")
        var viewModel = ImageHeaderCollectionViewCell.ViewModel(type: .animation(url: url, backgroundColor: response.orderDetails?.trackingColorCode ?? ""))
        viewModel.isShowSupportHeader = isShowButtons
        let header: TrackingHeaderType = .image(model: viewModel)
        return header
    }
}
