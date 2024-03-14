//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 28/11/2023.
//

import Foundation
import UIKit

struct OrderHasBeenDeliveredConfig: OrderTrackable, GetSupportable, CanceledOrderConfigProtocol {
    var response: OrderTrackingStatusResponse
    func buildConfig() -> GetSupportModel {
        var progressBar = orderProgressBar
        progressBar.step = .completed
        progressBar.hideTimeLabel = true
        
        let cells: [GetSupportCellType] = [
            .progressBar(model: progressBar)
        ]
        
        return .init(header: getImageHeader(image: "Delivered"), cells: cells + getSupportActions())
    }
    func build() -> OrderTrackingModel {
        var progressBar = orderProgressBar
        progressBar.step = .completed
        progressBar.hideTimeLabel = true
        var cells: [TrackingCellType] = [
            .progressBar(model: progressBar)
        ]
        
        if orderType == .pickup {
            cells.append(.orderActions(model: getOrderActionsModel()))
        } else {
            cells.append(.location(model: orderLocation))
        }
        
        if let orderRateModel {
            cells.append(.rating(model: orderRateModel))
        }
        
        if let orderPoint {
            cells.append(.point(model: orderPoint))
        }
        
        if let orderSubscription {
            cells.append(.subscription(model: orderSubscription))
        }
        
        return .init(header: getCanceledHeader(), cells: cells)
    }
    
   private func getCanceledHeader() -> TrackingHeaderType {
        let color = UIColor(red: 11, green: 68, blue: 18)
        let image = "Delivered"
        var viewModel = ImageHeaderCollectionViewCell.ViewModel(type: .image(imageName: image, backgroundColor: color))
        viewModel.isShowSupportHeader = true
        let header: TrackingHeaderType = .image(model: viewModel)
        return header
    }
}
