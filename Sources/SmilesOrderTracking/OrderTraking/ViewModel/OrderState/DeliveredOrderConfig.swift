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
        
        var rating = RatingCollectionViewCell.ViewModel()
        rating.cellType = .delivery
        var cells: [TrackingCellType] = [
            .progressBar(model: progressBar),
            .driver(model: orderDriverModel),
            .rating(model: rating),
            .location(model: location),
        ]
        
        if let orderSubscription {
            cells.append(.subscription(model: orderSubscription))
        }
        
        let header: TrackingHeaderType = .map(model: orderMapModel)
        return .init(header: header, cells: cells)
    }
}
