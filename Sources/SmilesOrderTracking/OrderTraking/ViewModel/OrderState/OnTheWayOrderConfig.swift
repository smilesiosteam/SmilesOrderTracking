//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 23/11/2023.
//

import Foundation

struct OnTheWayOrderConfig: OrderTrackable, GetSupportable {
    func buildConfig() -> GetSupportModel {
        var progressBar = orderProgressBar
        progressBar.step = .third
        progressBar.hideTimeLabel = false
        
        var cells: [GetSupportCellType] = [
            .progressBar(model: progressBar)
        ]
        
        // If the order will be delayed
        if let delayText = response.orderDetails?.delayStatusText, !delayText.isEmpty {
            cells.append(.text(model: .init(title: delayText)))
        }
        
        let header: GetSupportHeaderType = getSmallHeaderAnimated()
        return .init(header: header, cells: cells + getSupportActions())
    }
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .third
        progressBar.hideTimeLabel = false
        
        let location = orderLocation
        
        var cells: [TrackingCellType] = [
            .progressBar(model: progressBar)
        ]
        
        // If the order will be delayed
        if let delayText = response.orderDetails?.delayStatusText, !delayText.isEmpty {
            cells.append(.text(model: .init(title: delayText)))
        }
        
        // Will add driver cell in case isLiveTracking is true only
        if isLiveTracking {
            cells.append( .driver(model: orderDriverModel))
        }
        
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
    
    var isLiveTracking: Bool {
        response.orderDetails?.liveTracking ?? false
    }
}
