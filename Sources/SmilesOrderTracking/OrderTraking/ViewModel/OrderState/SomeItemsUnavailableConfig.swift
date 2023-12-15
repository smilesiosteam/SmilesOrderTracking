//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 28/11/2023.
//

import Foundation


struct SomeItemsUnavailableConfig: CanceledOrderConfigProtocol, GetSupportable {
    var response: OrderTrackingStatusResponse
   
    func buildConfig() -> GetSupportModel {
        var someItemsUnavailable = getOrderCancelledModel(buttonTitle: OrderTrackingLocalization.unavailableItemsButtonTitle.text)
        someItemsUnavailable.type = .someItemsUnavailable
        let cells: [GetSupportCellType] = [
            .text(model: getTextModel()),
        ]
        
        return .init(header: getImageHeader(image: "Cancelled"), cells: cells + getSupportActions())
    }
    func build() -> OrderTrackingModel {
        var someItemsUnavailable = getOrderCancelledModel(buttonTitle: OrderTrackingLocalization.unavailableItemsButtonTitle.text)
        someItemsUnavailable.type = .someItemsUnavailable
        var cells: [TrackingCellType] = [
            .text(model: getTextModel()),
            .orderCancelled(model: someItemsUnavailable)
        ]
        if let cashVoucher {
            cells.append(.cashVoucher(model: cashVoucher))
        }
        cells.append(.orderActions(model: getOrderActionsModel()))
        
        return .init(header: getCanceledHeader(), cells: cells)
    }
}
