//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 23/11/2023.
//

import Foundation

struct NearOfLocationConfig: OrderTrackable, GetSupportable {
    var response: OrderTrackingStatusResponse
    func buildConfig() -> GetSupportModel {
        var progressBar = orderProgressBar
        progressBar.step = .fourth
        progressBar.hideTimeLabel = false
        
        
        let cells: [GetSupportCellType] = [
            .progressBar(model: progressBar)
        ]
        return .init(header: getSmallHeaderAnimated(), cells: cells + getSupportActions())
    }
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .fourth
        progressBar.hideTimeLabel = false
        
        
        let location = orderLocation
        
        var cells: [TrackingCellType] = [
            .progressBar(model: progressBar)
        ]
        
        cells.append(.driver(model: orderDriverModel))
        cells.append(.location(model: location))
        
        if let orderPoint {
            cells.append(.point(model: orderPoint))
        }
        
        if let orderSubscription {
            cells.append(.subscription(model: orderSubscription))
        }
        
        let header: TrackingHeaderType = .map(model: orderMapModel)
        return .init(header: header, cells: cells)
    }
}
