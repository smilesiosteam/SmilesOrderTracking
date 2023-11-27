//
//  File.swift
//
//
//  Created by Ahmed Naguib on 20/11/2023.
//

import Foundation
import SmilesUtilities

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
        vieModel.startAddress = response.orderDetails?.restaurantAddress
        vieModel.endAddress = response.orderDetails?.deliveryAdrress
        vieModel.restaurantNumber = response.orderDetails?.restaurentNumber
        vieModel.orderId = response.orderDetails?.orderId
        return vieModel
    }
    
    var orderText: String? {
        response.orderDetails?.orderDescription
    }
    
    var orderPoint: PointsCollectionViewCell.ViewModel? {
        if let point = response.orderDetails?.earnPoints, point > 0 {
            var viewModel = PointsCollectionViewCell.ViewModel()
            viewModel.numberOfPoints = point
            viewModel.text = "smiles points earned and will be credited soon."
            return viewModel
        }
        return nil
    }
    
    var orderSubscription: FreeDeliveryCollectionViewCell.ViewModel? {
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
    
    var orderRestaurant: RestaurantCollectionViewCell.ViewModel {
        var viewModel = RestaurantCollectionViewCell.ViewModel()
        viewModel.name = response.orderDetails?.restaurantName
        viewModel.iconUrl = response.orderDetails?.iconUrl
        let orderItems = response.orderItems?.map({ "\($0.quantity ?? 0) x \($0.itemName ?? "")" }) ?? []
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
        
        let viewModel = MapHeaderCollectionViewCell.ViewModel(startPoint: startModel, endPoint: endModel, userImageURL: "")
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
        return viewModel
    }
    
    var isLiveTracking: Bool {
        response.orderDetails?.liveTracking ?? false
    }
    
    var orderRateModel: RatingCollectionViewCell.ViewModel? {
        let orderId = response.orderDetails?.orderId ?? 0
        var viewModel = RatingCollectionViewCell.ViewModel(orderId: orderId)
        let ratingModels = response.orderRating ?? []
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
}
