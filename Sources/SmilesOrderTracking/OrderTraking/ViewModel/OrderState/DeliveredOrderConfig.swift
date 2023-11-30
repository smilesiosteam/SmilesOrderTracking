//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 23/11/2023.
//

import Foundation

struct DeliveredOrderConfig: OrderTrackable {
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .completed
        progressBar.hideTimeLabel = true
        
        var location = orderLocation
        location.type = .details
        
        var cells: [TrackingCellType] = [
            .progressBar(model: progressBar)
        ]
        
        if let description = orderText {
            cells.append(.text(model: .init(title: description)))
        }
        
        cells.append(.driver(model: orderDriverModel))
        cells.append(.location(model: location))
        
        if let orderRateModel {
            cells.append(.rating(model: orderRateModel))
        }
        
        if let orderSubscription {
            cells.append(.subscription(model: orderSubscription))
        }
        
        var headerModel = orderMapModel
        headerModel.type = .image(imageName: "DriverArrived")
        let header: TrackingHeaderType = .map(model: headerModel)
        return .init(header: header, cells: cells)
    }
}
