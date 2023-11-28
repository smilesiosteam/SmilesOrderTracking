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
        orderActions.orderId = response.orderDetails?.orderId
        orderActions.restaurantNumber = response.orderDetails?.restaurentNumber
        return orderActions
    }
    
    func getTextModel() -> TextCollectionViewCell.ViewModel {
        var viewModel = TextCollectionViewCell.ViewModel()
        viewModel.title = orderText
        viewModel.type = .title
        return viewModel
    }
    
    func getOrderCancelledModel(title: String, buttonTitle: String) -> OrderCancelledTimerCollectionViewCell.ViewModel {
        var viewModel = OrderCancelledTimerCollectionViewCell.ViewModel()
        viewModel.buttonTitle = buttonTitle
        viewModel.title = title
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


protocol AnimationHeaderProtocol: OrderTrackable {
   
}

extension AnimationHeaderProtocol {
    func getAnimationHeader(isShowButtons: Bool) -> TrackingHeaderType {
        var viewModel = ImageHeaderCollectionViewCell.ViewModel(type: .animation(url: ""))
        viewModel.isShowSupportHeader = isShowButtons
        let header: TrackingHeaderType = .image(model: viewModel)
        return header
    }
}
