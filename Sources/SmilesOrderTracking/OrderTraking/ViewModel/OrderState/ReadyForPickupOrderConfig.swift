//
//  File.swift
//
//
//  Created by Ahmed Naguib on 29/11/2023.
//

import Foundation

struct ReadyForPickupOrderConfig: OrderTrackable {
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {
        
        var cells: [TrackingCellType] = [.progressBar(model: getProgressBarModel())]
        if let description = orderText {
            cells.append(.text(model: .init(title: description)))
        }
        
        cells.append(.driver(model: getDriverModel()))
        
        cells.append(.location(model: getLocationOrderModel()))
        
        if let orderSubscription {
            cells.append(.subscription(model: orderSubscription))
        }
        return .init(header: getHeaderModel(), cells: cells)
    }
    
    private func getProgressBarModel() -> OrderProgressCollectionViewCell.ViewModel {
        var progressBar = orderProgressBar
        progressBar.step = .fourth
        progressBar.hideTimeLabel = true
        return progressBar
    }
    private func getLocationOrderModel() -> LocationCollectionViewCell.ViewModel {
        var location = orderLocation
        location.type = .details
        return location
    }
    
    private func getDriverModel() -> DriverCollectionViewCell.ViewModel {
        var viewModel = orderDriverModel
        viewModel.title = OrderTrackingLocalization.pickUpOrderFrom.text
        viewModel.subTitle = response.orderDetails?.restaurantAddress
        viewModel.cellType = .pickup
        return viewModel
    }
    
    private func getHeaderModel() -> TrackingHeaderType {
        var header = orderMapModel
        header.type = .image(imageName: "DriverArrived")
        return .map(model: header)
    }
}