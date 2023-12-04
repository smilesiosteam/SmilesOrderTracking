//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 23/11/2023.
//

import Foundation

struct OnTheWayOrderConfig: OrderTrackable {
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .third
        progressBar.hideTimeLabel = false
        
        var location = orderLocation
        location.type = .details
        
        var cells: [TrackingCellType] = [
            .progressBar(model: progressBar)
        ]
        
        // If the order will be delayed
        if let deliveryDelayTitle = response.orderDetails?.delayAlert?.title,
            !deliveryDelayTitle.isEmpty {
            let text = "\(deliveryDelayTitle) \n \(response.orderDetails?.delayAlert?.description ?? "")"
            cells.append(.text(model: .init(title: text)))
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
