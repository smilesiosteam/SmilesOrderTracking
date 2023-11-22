//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 21/11/2023.
//

import Foundation

struct ConfigWaitingOrder: OrderTrackable {
    var response: OrderTrackingResponseModel
    
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .first
        
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
        
        let header: TrackingHeaderType = .image(model: .init(isShowSupportHeader: true))
        return .init(header: header, cells: cells)
    }
}
