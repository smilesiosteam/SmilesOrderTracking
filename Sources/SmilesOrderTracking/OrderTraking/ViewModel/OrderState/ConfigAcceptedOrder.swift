//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 21/11/2023.
//

import Foundation


struct ConfigAcceptedOrder: OrderTrackable {
    var response: OrderTrackingResponseModel
    
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .second
        progressBar.hideTimeLabel = true
        progressBar.title = OrderTrackingLocalization.orderAccepted.text
        
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
        
        let header: TrackingHeaderType = .map(model: orderMapModel)
        return .init(header: header, cells: cells)
    }
}
