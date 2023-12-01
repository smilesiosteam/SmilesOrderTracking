//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 20/11/2023.
//

import Foundation

enum TrackingCellType {
    case progressBar(model: OrderProgressCollectionViewCell.ViewModel)
    case text(model: TextCollectionViewCell.ViewModel)
    case location(model: LocationCollectionViewCell.ViewModel)
    case restaurant(model: RestaurantCollectionViewCell.ViewModel)
    case subscription(model: FreeDeliveryCollectionViewCell.ViewModel)
    case point(model: PointsCollectionViewCell.ViewModel)
    case driver(model: DriverCollectionViewCell.ViewModel)
    case rating(model: RatingCollectionViewCell.ViewModel)
    case confirmation(model: OrderConfirmationCollectionViewCell.ViewModel)
    case orderActions(model: OrderCancelledCollectionViewCell.ViewModel)
    case cashVoucher(model: CashCollectionViewCell.ViewModel)
    case orderCancelled(model: OrderCancelledTimerCollectionViewCell.ViewModel)
}

enum TrackingHeaderType {
    case image(model: ImageHeaderCollectionViewCell.ViewModel)
    case map(model: MapHeaderCollectionViewCell.ViewModel)
}

struct OrderTrackingModel {
    var header: TrackingHeaderType = .image(model: .init(type: .animation(url: nil)))
    var cells: [TrackingCellType] = []
}
