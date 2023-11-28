//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 28/11/2023.
//

import Foundation


struct SomeItemsUnavailableConfig: CanceledOrderConfigProtocol {
    var response: OrderTrackingStatusResponse
    
    func build() -> OrderTrackingModel {
        let cells: [TrackingCellType] = [
            .text(model: getTextModel()),
            .orderCancelled(
                model: getOrderCancelledModel(title: OrderTrackingLocalization.unavailableItemsTitle.text,
                                              buttonTitle: OrderTrackingLocalization.unavailableItemsButtonTitle.text)),
            .cashVoucher(model: .init()),
            .orderActions(model: getOrderActionsModel())
        ]
        
        return .init(header: getHeader(), cells: cells)
    }
}
