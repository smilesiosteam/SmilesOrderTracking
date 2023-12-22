//
//  File.swift
//
//
//  Created by Ahmed Naguib on 14/12/2023.
//

import Foundation
import SmilesTests
@testable import SmilesOrderTracking

enum OrderStatusStub {
    static var getOrderStatusModel: OrderTrackingStatusResponse {
        let model: OrderTrackingStatusResponse? = readJsonFile("Order_Tracking_Model", bundle: .module)
        return model ?? .init()
    }
    
    static var location: LocationCollectionViewCell.ViewModel {
        let orderDetails = getOrderStatusModel.orderDetails
        var location = LocationCollectionViewCell.ViewModel()
        location.startAddress = orderDetails?.restaurantAddress
        location.endAddress = orderDetails?.deliveryAdrress
        location.restaurantNumber = orderDetails?.restaurentNumber
        location.orderId = "466715"
        location.restaurantId = "17338"
        location.type = .showCancelButton
        return location
    }
    
    static var progressBar: OrderProgressCollectionViewCell.ViewModel {
        let title = getOrderStatusModel.orderDetails?.title
        var bar: OrderProgressCollectionViewCell.ViewModel = .init()
        bar.title = title
        bar.step = .second
        bar.time = getOrderStatusModel.orderDetails?.deliveryTimeRangeText
        bar.hideTimeLabel = false
        return bar
    }
    
    static var point:PointsCollectionViewCell.ViewModel {
        let response = getOrderStatusModel
        let pointCount = response.orderDetails?.earnPoints ?? 0
        var pointModel = PointsCollectionViewCell.ViewModel()
        pointModel.numberOfPoints = pointCount
        pointModel.text = response.orderDetails?.earnPointsText
        return pointModel
    }
    
    static var subscription: FreeDeliveryCollectionViewCell.ViewModel {
        let response = getOrderStatusModel
        let bannerImageUrl = response.orderDetails?.subscriptionBannerV2?.bannerImageUrl ?? ""
        var viewModel = FreeDeliveryCollectionViewCell.ViewModel()
        viewModel.imageURL = bannerImageUrl
        viewModel.redirectUrl = response.orderDetails?.subscriptionBannerV2?.redirectionUrl ?? ""
        return viewModel
    }
    
    static var driver: DriverCollectionViewCell.ViewModel {
        let response = getOrderStatusModel
        var viewModel = DriverCollectionViewCell.ViewModel()
        let orderDetails = response.orderDetails
        viewModel.title = orderDetails?.driverName
        viewModel.lat = Double(orderDetails?.latitude ?? "") ?? 0.0
        viewModel.lng = Double(orderDetails?.longitude ?? "") ?? 0.0
        viewModel.subTitle = orderDetails?.driverStatusText
        viewModel.cellType = .delivery
        viewModel.driverMobileNumber = response.orderDetails?.partnerNumber
        return viewModel
    }
    
    static var mapHeader: TrackingHeaderType {
        let response = getOrderStatusModel
        let startModel = MarkerModel(lat: 25.2113, lang: 55.2743, image: "startPin")
        let endModel = MarkerModel(lat: 25.230, lang: 55.291, image: "endPin")
        let url = URL(string: response.orderDetails?.smallImageAnimationUrl ?? "")
        let headerModel = MapHeaderCollectionViewCell.ViewModel(startPoint: startModel, endPoint: endModel, type: .animation(url: url))
        let header: TrackingHeaderType = .map(model: headerModel)
        return header
    }
    
    static var cancelModel: OrderCancelledTimerCollectionViewCell.ViewModel {
        let response = getOrderStatusModel
        var viewModel = OrderCancelledTimerCollectionViewCell.ViewModel()
        let orderId = response.orderDetails?.orderId ?? 0
        viewModel.orderId = "\(orderId)"
        viewModel.orderNumber = response.orderDetails?.orderNumber ?? ""
        viewModel.title = response.orderDetails?.orderDescription ?? ""
        viewModel.restaurantAddress = response.orderDetails?.restaurantAddress ?? ""
        return viewModel
    }
    
    static var text:  TextCollectionViewCell.ViewModel {
        var viewModel = TextCollectionViewCell.ViewModel()
        viewModel.title = getOrderStatusModel.orderDetails?.title
        viewModel.type = .title
        return viewModel
    }
    
   static var cashVoucher: CashCollectionViewCell.ViewModel {
        var viewModel = CashCollectionViewCell.ViewModel()
        let response = getOrderStatusModel
        viewModel.title = response.orderDetails?.refundTitle
        viewModel.description = response.orderDetails?.refundDescription
        viewModel.iconUrl = response.orderDetails?.refundIcon
        return viewModel
    }
    
    static var orderAction: OrderCancelledCollectionViewCell.ViewModel {
        let response = getOrderStatusModel
        var orderActions = OrderCancelledCollectionViewCell.ViewModel()
        let orderId = response.orderDetails?.orderId ?? 0
        orderActions.orderId = "\(orderId)"
        orderActions.restaurantId = response.orderDetails?.restaurantId ?? ""
        orderActions.restaurantNumber = response.orderDetails?.restaurentNumber
        return orderActions
    }
}
