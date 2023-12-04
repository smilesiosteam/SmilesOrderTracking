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
        var someItemsUnavailable = getOrderCancelledModel(buttonTitle: OrderTrackingLocalization.unavailableItemsButtonTitle.text)
        someItemsUnavailable.type = .someItemsUnavailable
        let cells: [TrackingCellType] = [
            .text(model: getTextModel()),
            .orderCancelled(model: someItemsUnavailable),
//            .cashVoucher(model: .init()),
            .orderActions(model: getOrderActionsModel())
        ]
        
        return .init(header: getCanceledHeader(), cells: cells)
    }
}
