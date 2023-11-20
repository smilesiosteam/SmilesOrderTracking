//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 14/11/2023.
//

import Foundation

final class OrderTrackingViewModel {
    var orderStatusModel = OrderTrackingModel()
    var firebaseDatabaseManager = FirebaseDatabaseManager()
    
    init() {
        firebaseDatabaseManager.delegate = self
        configProcessingOrder()
    }
    
    private func configProcessingOrder() {
        let progressBar: OrderProgressCollectionViewCell.ViewModel = .init(step: .first(percentage: 0.7), title: "Processing your order")
        var location: LocationCollectionViewCell.ViewModel = .init()
        location.startAddress = "McDonald's, Dubai Marina Mall Food..."
        location.endAddress = "Silver Tower, 1902 Apartment, Business ..."
        location.type = .cancel
        
        var restaurant: RestaurantCollectionViewCell.ViewModel = .init()
        restaurant.items = ["1 x Classic Chicken Burger", "1 x Veggie Burger"]
        restaurant.name = "Smoke Burger"
        let orderStatus: [TrackingCellType] = [.progressBar(model: progressBar),
                       .text(message: "Please wait while we send your order to the restaurant."),
                       .location(model: location),
                       .restaurant(model: restaurant)
        ]
        let header = ImageHeaderCollectionViewCell.ViewModel(isShowSupportHeader: true)
        orderStatusModel = OrderTrackingModel(header: .image(model: header), items: orderStatus)
    }
    
    func support() {
        print("Suppert Tapped")
    }
}

// MARK: - FirebaseDatabaseManagerDelegate
extension OrderTrackingViewModel: FirebaseDatabaseManagerDelegate {
    func orderStatusDidChange(with orderId: String, orderNumber: String, orderStatus: OrderTrackingType, comingFromFirebase: Bool) {
        // Todo: Call getOrderStatus api here
    }
    
    func liveLocationDidUpdate(with latitude: Double, longitude: Double) {
        // Todo: Update rider location on map
    }
}
