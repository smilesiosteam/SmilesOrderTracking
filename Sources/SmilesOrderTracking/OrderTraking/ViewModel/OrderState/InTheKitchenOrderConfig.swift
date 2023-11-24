//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 22/11/2023.
//

import Foundation

struct InTheKitchenOrderConfig: OrderTrackable {
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .second
        progressBar.hideTimeLabel = false
        
        var location = orderLocation
        location.type = .details
        
        var cells: [TrackingCellType] = [
            .progressBar(model: progressBar),
            .location(model: location),
        ]
        
        if let orderPoint {
            cells.append(.point(model: orderPoint))
        }
        
        if let orderSubscription {
            cells.append(.subscription(model: orderSubscription))
        }
        
        var header: TrackingHeaderType = .map(model: orderMapModel)
        header = isLiveTracking ? header : .image(model: .init(isShowSupportHeader: true))
        return .init(header: header, cells: cells)
    }
}
