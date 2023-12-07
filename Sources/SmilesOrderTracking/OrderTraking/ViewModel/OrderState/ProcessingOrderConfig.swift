//
//  File.swift
//
//
//  Created by Ahmed Naguib on 21/11/2023.
//

import Foundation

struct ProcessingOrderConfig: OrderTrackable, AnimationHeaderProtocol, GetSupportable {
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
        let cells: [TrackingCellType] = [
            .progressBar(model: progressBar),
            .text(model: .init(title: text)),
            .location(model: getOrderLocation()),
            .restaurant(model: orderRestaurant)
        ]
        
        return .init(header: getAnimationHeader(isShowButtons: false), cells: cells)
    }
    
    private func getOrderLocation() -> LocationCollectionViewCell.ViewModel {
        var location = orderLocation
        location.type = isCancelationAllowed ? .showCancelButton : .hideAllButtons
        
        let showCancelButtonTimeout = response.orderDetails?.showCancelButtonTimeout ?? false
        location.type = showCancelButtonTimeout ? .hideAllButtons : location.type
        return location
    }
    
    var isCancelationAllowed: Bool {
        response.orderDetails?.isCancelationAllowed ?? true
    }
}
