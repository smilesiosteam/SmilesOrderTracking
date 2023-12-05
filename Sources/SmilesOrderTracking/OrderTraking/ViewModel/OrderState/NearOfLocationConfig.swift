//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 23/11/2023.
//

import Foundation

struct NearOfLocationConfig: OrderTrackable {
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .fourth
        progressBar.hideTimeLabel = false
        
        
        var location = orderLocation
        location.type = .details
        
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
