//
//  File.swift
//
//
//  Created by Ahmed Naguib on 22/11/2023.
//

import Foundation

struct InTheKitchenOrderConfig: OrderTrackable, GetSupportable {
    var response: OrderTrackingStatusResponse
    
    func buildConfig() -> GetSupportModel {
        var cells: [GetSupportCellType] = [.progressBar(model: getProgressBarModel())]
        
      
        if let delayText = response.orderDetails?.delayStatusText, !delayText.isEmpty {
            cells.append(.text(model: .init(title: delayText)))
        }
        
        
        let header: GetSupportHeaderType = getSmallHeaderAnimated()
        return .init(header: header, cells: cells + getSupportActions())
    }
    func build() -> OrderTrackingModel {
        
        var cells: [TrackingCellType] = [.progressBar(model: getProgressBarModel())]
        
      
        if let delayText = response.orderDetails?.delayStatusText, !delayText.isEmpty {
            cells.append(.text(model: .init(title: delayText)))
        }
        
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
