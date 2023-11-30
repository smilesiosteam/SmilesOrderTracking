//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 21/11/2023.
//

import Foundation

struct ProcessingOrderConfig: OrderTrackable, AnimationHeaderProtocol {
    var response: OrderTrackingStatusResponse
    var hideCancelButton: () -> Void = {}
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .first
        
        let cells: [TrackingCellType] = [
            .progressBar(model: progressBar),
            .text(model: .init(title: orderText)),
            .location(model: getOrderLocation()),
            .restaurant(model: orderRestaurant)
        ]
        
        return .init(header: getAnimationHeader(isShowButtons: true), cells: cells)
    }
    
    private func getOrderLocation() ->  LocationCollectionViewCell.ViewModel {
//        var location = orderLocation
//        let isCancelationAllowed = response.orderDetails?.isCancelationAllowed ?? true
//        location.type = isCancelationAllowed ? .showCancelButton : .hideAllButtons
//        fireCancelButton(isShowCancelButton: isCancelationAllowed)
//        // This for hide cancel button after 10 seconds
//        let showCancelButtonTimeout = response.orderDetails?.showCancelButtonTimeout ?? false
//        location.type = showCancelButtonTimeout ? .hideAllButtons :  location.type
//        return location
        
        // Demo
        var location = orderLocation
        location.type = .showCancelButton
        return location
    }
    
    private func fireCancelButton(isShowCancelButton: Bool) {
        
        guard isShowCancelButton else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.hideCancelButton()
        }
    }
}
