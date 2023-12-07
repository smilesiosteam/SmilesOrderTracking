//
//  File.swift
//
//
//  Created by Ahmed Naguib on 20/11/2023.
//

import Foundation
import SmilesUtilities
import UIKit

protocol GetSupportable {
    var response: OrderTrackingStatusResponse { get set }
    func buildConfig() -> GetSupportModel
}
extension GetSupportable {
    func getSupportModel(type:SmilesSupportActionType)-> GetSupportCollectionViewCell.ViewModel? {
        if let order = response.orderDetails {
            var viewModel = GetSupportCollectionViewCell.ViewModel(type: type,order: order)
            return viewModel
        }
        return nil
    }
    func getImageHeaderAnimated() -> GetSupportHeaderType {
        let url = URL(string: response.orderDetails?.largeImageAnimationUrl ?? "")
        var viewModel = GetSupportImageHeaderCollectionViewCell.ViewModel(type: .animation(url: url))
        let header: GetSupportHeaderType = .supportImageHeader(model: viewModel)
        return header
    }
    func getImageHeader(image:String) -> GetSupportHeaderType {
        let color = UIColor(red: 74, green: 9, blue: 0)
        var viewModel = GetSupportImageHeaderCollectionViewCell.ViewModel(type: .image(imageName: image))
        let header: GetSupportHeaderType = .supportImageHeader(model: viewModel)
        return header
    }
    func getSupportActions()->[GetSupportCellType]{
        var actions:[GetSupportCellType] = [getSupportModel(type: .openFAQ)]
        if !(response.restaurentNumber?.isEmpty ?? true) {
            actions.append(getSupportModel(type: .callRestaurant))
        }
        if !(response.partnerNumber?.isEmpty ?? true) {
            actions.append(getSupportModel(type: .callChampion))
        }
        if response.orderDetails?.isLiveChatEnable ?? false {
            actions.append(getSupportModel(type: .liveChat))
        }
        return actions
        
    }
}
