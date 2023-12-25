//
//  File.swift
//
//
//  Created by Ahmed Naguib on 29/11/2023.
//

import Foundation

struct ReadyForPickupOrderConfig: OrderTrackable, GetSupportable {
    var response: OrderTrackingStatusResponse
    
    func buildConfig() -> GetSupportModel {
        let cells: [GetSupportCellType] = [.progressBar(model: getProgressBarModel())]
        return .init(header: getImageHeader(image: "DriverArrived"), cells: cells + getSupportActions())
    }
    func build() -> OrderTrackingModel {
        
        var cells: [TrackingCellType] = [.progressBar(model: getProgressBarModel())]
        
        cells.append(.driver(model: getDriverModel()))
        
        cells.append(.location(model: orderLocation))
        
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
    
    private func getDriverModel() -> DriverCollectionViewCell.ViewModel {
        var viewModel = orderDriverModel
        viewModel.title = OrderTrackingLocalization.pickUpOrderFrom.text
        viewModel.subTitle = response.orderDetails?.restaurantAddress
        viewModel.cellType = .pickup
        viewModel.placeName = response.orderDetails?.restaurantName ?? ""
        return viewModel
    }
    
    private func getHeaderModel() -> TrackingHeaderType {
        var header = orderMapModel
        header.type = .image(imageName: "DriverArrived")
        return .map(model: header)
    }
}
