//
//  File.swift
//
//
//  Created by Ahmed Naguib on 21/11/2023.
//

import Foundation

struct ProcessingOrderConfig: OrderTrackable, AnimationHeaderProtocol, GetSupportable, CanceledOrderConfigProtocol {
    // This for get support view
    func buildConfig() -> GetSupportModel {
        var progressBar = orderProgressBar
        progressBar.step = .first
        let cells: [GetSupportCellType] = [
            .progressBar(model: progressBar),
            .text(model: .init(title: orderText)),
        ]
        return .init(header: getImageHeaderAnimated(), cells: cells + getSupportActions())
    }
    
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .first
        var text: String?
        if let delayText = response.orderDetails?.delayStatusText, !delayText.isEmpty {
            text = delayText
        } else {
            text = orderText
        }
        
        var cells: [TrackingCellType] = [
            .progressBar(model: progressBar),
            .text(model: .init(title: text)),
        ]
        
        if orderType == .pickup {
            cells.append(.orderActions(model: getOrderActionsModel()))
        } else {
            cells.append(.location(model: getOrderLocation()))
        }
        cells.append(.restaurant(model: orderRestaurant))
        
        return .init(header: getAnimationHeader(isShowButtons: true), cells: cells)
    }
    
    private func getOrderLocation() -> LocationCollectionViewCell.ViewModel {
        var location = orderLocation
        location.type = isCancelationAllowed ? .showCancelButton : location.type
        
        let showCancelButtonTimeout = response.orderDetails?.showCancelButtonTimeout ?? false
        if !isCancelationAllowed, showCancelButtonTimeout {
            location.type = orderLocation.type
        }
        
        return location
    }
    
    var isCancelationAllowed: Bool {
        response.orderDetails?.isCancelationAllowed ?? true
    }
}
