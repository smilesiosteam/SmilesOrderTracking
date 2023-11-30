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
        
        if let description = orderText {
            cells.append(.text(model: .init(title: description)))
        }
        
        cells.append( .driver(model: orderDriverModel))
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
