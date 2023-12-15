//
//  File.swift
//
//
//  Created by Ahmed Naguib on 27/11/2023.
//

import Foundation

struct CanceledOrderConfig: CanceledOrderConfigProtocol, GetSupportable {
    var response: OrderTrackingStatusResponse
    func buildConfig() -> GetSupportModel {
        var orderCancelledModel = getOrderCancelledModel(buttonTitle: OrderTrackingLocalization.restaurantCanceledButtonTitle.text)
        orderCancelledModel.type = .cancelled
        let cells: [GetSupportCellType] = [
            .text(model: getTextModel()),
        ]
        return .init(header: getImageHeader(image: "Cancelled"), cells: cells + getSupportActions())
    }
    func build() -> OrderTrackingModel {
        var orderCancelledModel = getOrderCancelledModel(buttonTitle: OrderTrackingLocalization.restaurantCanceledButtonTitle.text)
        orderCancelledModel.type = .cancelled
        var cells: [TrackingCellType] = [
            .text(model: getTextModel()),
            .orderCancelled(model: orderCancelledModel),
        ]
        if let cashVoucher {
            cells.append(.cashVoucher(model: cashVoucher))
        }
        cells.append(.orderActions(model: getOrderActionsModel()))
        
        
        
        return .init(header: getCanceledHeader(), cells: cells)
    }
}
