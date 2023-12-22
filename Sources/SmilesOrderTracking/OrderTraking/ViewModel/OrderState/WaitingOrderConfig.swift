//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 21/11/2023.
//

import Foundation

struct WaitingOrderConfig: OrderTrackable, AnimationHeaderProtocol, GetSupportable {
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .first
        
        let location = orderLocation
        
        var cells: [TrackingCellType] = [
            .progressBar(model: progressBar)
        ]
        
        if let orderText = orderText {
            cells.append(.text(model: .init(title: orderText)))
        }
        
        cells.append(.location(model: location))
        
        if let orderPoint {
            cells.append(.point(model: orderPoint))
        }
        
        if let orderSubscription {
            cells.append(.subscription(model: orderSubscription))
        }
        
       
        return .init(header: getAnimationHeader(isShowButtons: true), cells: cells)
    }
    func buildConfig() -> GetSupportModel {
        var progressBar = orderProgressBar
        progressBar.step = .first
        
        var cells: [GetSupportCellType] = [
            .progressBar(model: progressBar)
        ]
        
        if let orderText = orderText {
            cells.append(.text(model: .init(title: orderText)))
        }
       
        return .init(header: getImageHeaderAnimated(), cells: cells + getSupportActions())
    }
}
