//
//  File.swift
//
//
//  Created by Ahmed Naguib on 20/11/2023.
//

import Foundation

protocol OrderTrackable {
    var response: OrderTrackingStatusResponse { get set }
}

extension OrderTrackable {
    var progressBar: OrderProgressCollectionViewCell.ViewModel {
        var vieModel = OrderProgressCollectionViewCell.ViewModel()
        vieModel.time = response.orderDetails?.deliveryTimeRangeText
        vieModel.title = response.orderDetails?.title
        return vieModel
    }
    
    var location: LocationCollectionViewCell.ViewModel {
        var vieModel = LocationCollectionViewCell.ViewModel()
        vieModel.startAddress = response.orderDetails?.restaurantAddress
        vieModel.endAddress = response.orderDetails?.deliveryAdrress
        vieModel.restaurantNumber = response.orderDetails?.restaurentNumber
        vieModel.orderId = response.orderDetails?.orderId
        return .init()
    }
    
    var text: String? {
        response.orderDetails?.orderDescription
    }
    
    var point: PointsCollectionViewCell.ViewModel? {
        if let point = response.orderDetails?.earnPoints, point > 0 {
            var viewModel = PointsCollectionViewCell.ViewModel()
            viewModel.numberOfPoints = point
            viewModel.text = "smiles points earned and will be credited soon."
        }
        return nil
    }
    
    var subscription: FreeDeliveryCollectionViewCell.ViewModel? {
        if let subscriptionModel = response.orderDetails?.subscriptionBanner {
            var viewModel = FreeDeliveryCollectionViewCell.ViewModel()
            viewModel.iconUrl = subscriptionModel.subscriptionIcon
            viewModel.redirectUrl = subscriptionModel.redirectionUrl
            viewModel.title = subscriptionModel.subscriptionTitle
            viewModel.subTitle = "No set Yet"
            return viewModel
        }
        
        return nil
    }
}
