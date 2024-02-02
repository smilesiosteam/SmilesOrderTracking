//
//  File.swift
//
//
//  Created by Ahmed Naguib on 20/11/2023.
//

import Foundation
import SmilesUtilities
import SmilesLanguageManager
protocol OrderTrackable {
    var response: OrderTrackingStatusResponse { get set }
    func build() -> OrderTrackingModel
}

extension OrderTrackable {
    var orderProgressBar: OrderProgressCollectionViewCell.ViewModel {
        var vieModel = OrderProgressCollectionViewCell.ViewModel()
        vieModel.time = response.orderDetails?.deliveryTimeRangeText
        vieModel.title = response.orderDetails?.title
        return vieModel
    }
    
    var orderLocation: LocationCollectionViewCell.ViewModel {
        var vieModel = LocationCollectionViewCell.ViewModel()
        if orderType == .delivery {
            vieModel.startAddress = response.orderDetails?.restaurantAddress
            vieModel.endAddress = response.orderDetails?.deliveryAdrress
        } else {
            vieModel.startAddress = response.orderDetails?.deliveryAdrress
            vieModel.endAddress = response.orderDetails?.restaurantAddress
        }
        
        let restaurantNumber = (response.orderDetails?.restaurentNumber).asStringOrEmpty()
        vieModel.restaurantNumber = restaurantNumber
        let orderId = response.orderDetails?.orderId
        let restaurantId = response.orderDetails?.restaurantId
        vieModel.orderId = "\(orderId.asIntOrEmpty())"
        vieModel.restaurantId = restaurantId.asStringOrEmpty()
        vieModel.type = restaurantNumber.isEmpty ? .hideCallButton : .details
        vieModel.orderType = orderType
        return vieModel
    }
    
    var orderText: String? {
        if let text = response.orderDetails?.orderDescription, !text.isEmpty {
            return text
        }
        return nil
    }
    
    var orderPoint: PointsCollectionViewCell.ViewModel? {
        if let point = response.orderDetails?.earnPoints, point > 0 {
            var viewModel = PointsCollectionViewCell.ViewModel()
            viewModel.numberOfPoints = point
            viewModel.text = response.orderDetails?.earnPointsText
            return viewModel
        }
        return nil
    }
    
    var orderSubscription: FreeDeliveryCollectionViewCell.ViewModel? {
        if let bannerImageUrl = response.orderDetails?.subscriptionBannerV2?.bannerImageUrl {
            var viewModel = FreeDeliveryCollectionViewCell.ViewModel()
            viewModel.imageURL = bannerImageUrl
            viewModel.redirectUrl = response.orderDetails?.subscriptionBannerV2?.redirectionUrl ?? ""
            return viewModel
        }
        return nil
    }
    
    var orderRestaurant: RestaurantCollectionViewCell.ViewModel {
        var viewModel = RestaurantCollectionViewCell.ViewModel()
        viewModel.name = response.orderDetails?.restaurantName
        viewModel.iconUrl = response.orderDetails?.iconUrl
        var orderItems: [String] = []
        if SmilesLanguageManager.shared.isRightToLeft {
            orderItems = response.orderItems?.map({ " \($0.itemName ?? "") x \($0.quantity ?? 0)" }) ?? []
        } else {
        orderItems = response.orderItems?.map({ "\($0.quantity ?? 0) x \($0.itemName ?? "")" }) ?? []
        }
       
        viewModel.items = orderItems.joined(separator: "\n")
        return viewModel
    }
    
    var orderMapModel: MapHeaderCollectionViewCell.ViewModel {
        let orderDetails = response.orderDetails
        
        let startLat = Double(orderDetails?.latitude ?? "") ?? 0.0
        let startLang = Double(orderDetails?.longitude ?? "") ?? 0.0
        let startImage = "startPin"
        let startModel = MarkerModel(lat: startLat, lang: startLang, image: startImage)
        
        let endLat = Double(orderDetails?.deliveryLatitude ?? "") ?? 0.0
        let endLang = Double(orderDetails?.deliveryLongitude ?? "") ?? 0.0
        let endImage = "endPin"
        let endModel = MarkerModel(lat: endLat, lang: endLang, image: endImage)
        
        let url = URL(string: response.orderDetails?.smallImageAnimationUrl ?? "")
        let viewModel = MapHeaderCollectionViewCell.ViewModel(startPoint: startModel, endPoint: endModel, type: .animation(url: url))
        return viewModel
    }
    
    var orderDriverModel: DriverCollectionViewCell.ViewModel {
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
    
    var isLiveTracking: Bool {
        response.orderDetails?.liveTracking ?? false
    }
    
    var orderRateModel: RatingCollectionViewCell.ViewModel? {
        let orderId = response.orderDetails?.orderId ?? 0
        var viewModel = RatingCollectionViewCell.ViewModel(orderId: orderId)
        let ratingModels = response.orderDetails?.orderRatings ?? []
        let rates = ratingModels.compactMap { ratingModel -> RatingCollectionViewCell.RateModel? in
            guard let type = RatingCollectionViewCell.RateType(rawValue: ratingModel.ratingType ?? "") else {
                return nil
            }
            
            let model = RatingCollectionViewCell.RateModel(type: type, title: ratingModel.title, iconUrl: ratingModel.image)
            return model
        }
        
        viewModel.items = rates
        return rates.isEmpty ? nil : viewModel
    }
    
    var orderType: OrderTrackingCellType {
        let orderType = response.orderDetails?.orderType ?? ""
        return OrderTrackingCellType(rawValue: orderType) ?? .delivery
    }
    
    var cashVoucher: CashCollectionViewCell.ViewModel? {
        var viewModel = CashCollectionViewCell.ViewModel()
        
        guard let title = response.orderDetails?.refundTitle, !title.isEmpty else { return nil }
        viewModel.title = title
        viewModel.description = response.orderDetails?.refundDescription
        viewModel.iconUrl = response.orderDetails?.refundIcon
        return viewModel
    }
}
