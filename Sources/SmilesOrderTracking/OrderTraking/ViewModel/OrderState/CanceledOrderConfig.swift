//
//  File.swift
//
//
//  Created by Ahmed Naguib on 27/11/2023.
//

import Foundation

struct CanceledOrderConfig: CanceledOrderConfigProtocol {
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {
        let cells: [TrackingCellType] = [
            .text(model: getTextModel()),
            .orderCancelled(
                model: getOrderCancelledModel(title: OrderTrackingLocalization.restaurantCanceledTitle.text,
                                              buttonTitle: OrderTrackingLocalization.restaurantCanceledButtonTitle.text)),
            .cashVoucher(model: .init()),
            .orderActions(model: getOrderActionsModel())
        ]
        
        return .init(header: getHeader(), cells: cells)
    }
}
