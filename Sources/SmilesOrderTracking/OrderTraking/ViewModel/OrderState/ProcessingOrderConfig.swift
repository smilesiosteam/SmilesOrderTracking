//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 21/11/2023.
//

import Foundation

struct ProcessingOrderConfig: OrderTrackable {
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .first
        
        var location = orderLocation
        location.type = .cancel
        
        let cells: [TrackingCellType] = [
            .progressBar(model: progressBar),
            .text(model: .init(title: orderText)),
            .location(model: location),
            .restaurant(model: orderRestaurant)
        ]
        
        let header: TrackingHeaderType = .image(model: .init(isShowSupportHeader: false))
        return .init(header: header, cells: cells)
    }
}
