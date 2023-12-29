//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 27/12/2023.
//


import Foundation
import UIKit

struct DeliveredOrderConfig: OrderTrackable, GetSupportable {
    var response: OrderTrackingStatusResponse
    func buildConfig() -> GetSupportModel {
        var progressBar = orderProgressBar
        progressBar.step = .completed
        progressBar.hideTimeLabel = true
        
        let cells: [GetSupportCellType] = [
            .progressBar(model: progressBar)
        ]
        let imageName = isLiveTracking ? "DriverArrived" : "Delivered"
        return .init(header: getImageHeader(image: imageName), cells: cells + getSupportActions())
    }
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .completed
        progressBar.hideTimeLabel = true
        
        let location = orderLocation
        
        var cells: [TrackingCellType] = [
            .progressBar(model: progressBar)
        ]
        
        if isLiveTracking {
            cells.append(.driver(model: orderDriverModel))
        }
        
        cells.append(.location(model: location))
        
        if let orderRateModel {
            cells.append(.rating(model: orderRateModel))
        }
        
        if let orderPoint {
            cells.append(.point(model: orderPoint))
        }
        
        if let orderSubscription {
            cells.append(.subscription(model: orderSubscription))
        }
        
        return .init(header: header, cells: cells)
    }
    
   private func getCanceledHeader() -> TrackingHeaderType {
        let color = UIColor(red: 11, green: 68, blue: 18)
        let image = "Delivered"
        var viewModel = ImageHeaderCollectionViewCell.ViewModel(type: .image(imageName: image, backgroundColor: color))
        viewModel.isShowSupportHeader = true
        let header: TrackingHeaderType = .image(model: viewModel)
        return header
    }
    
    private var isLiveTracking: Bool {
        (response.orderDetails?.liveTracking).asBoolOrFalse()
    }
    
    private var header: TrackingHeaderType {
        var headerModel = orderMapModel
        headerModel.type = .image(imageName: "DriverArrived")
       return isLiveTracking ? .map(model: headerModel) : getCanceledHeader()
    }
}
