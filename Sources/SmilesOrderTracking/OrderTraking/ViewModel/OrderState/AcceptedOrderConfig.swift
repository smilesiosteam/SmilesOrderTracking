//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 21/11/2023.
//

import Foundation

struct AcceptedOrderConfig: OrderTrackable, GetSupportable {
    func buildConfig() -> GetSupportModel {
        let cells: [GetSupportCellType] = [
            .progressBar(model: getProgressBarModel())
        ]
        let header: GetSupportHeaderType = getSmallHeaderAnimated()
        return .init(header: header, cells: cells + getSupportActions())
    }
    
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {

        var cells: [TrackingCellType] = [
            .progressBar(model: getProgressBarModel())
        ]
        
        if orderType == .pickup {
            cells.append(.driver(model: getDriverModel()))
        }
        
        cells.append(.location(model: orderLocation))
        if let orderPoint {
            cells.append(.point(model: orderPoint))
        }
        
        if let orderSubscription {
            cells.append(.subscription(model: orderSubscription))
        }
        
        let header: TrackingHeaderType = .map(model: orderMapModel)
        return .init(header: header, cells: cells)
    }
    
    private func getProgressBarModel() -> OrderProgressCollectionViewCell.ViewModel {
        var progressBar = orderProgressBar
        progressBar.step = .second
        progressBar.hideTimeLabel = false
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
}
