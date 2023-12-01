//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 30/11/2023.
//

import Foundation
import UIKit

public struct OrderTrackingDependance {
    public var orderId: String
    public var orderNUmber: String
    
    public init(orderId: String, orderNUmber: String) {
        self.orderId = orderId
        self.orderNUmber = orderNUmber
    }
}

public enum TrackOrderConfigurator {
    
    public static func getOrderTrackingView(dependance: OrderTrackingDependance, 
                                            navigationDelegate: OrderTrackingNavigationProtocol,
                                            navigationFlow: @escaping (OrderTrackingNavigation)
                                            -> Void) -> UIViewController {
        let useCase = OrderTrackingUseCase(orderId: dependance.orderId, orderNumber: dependance.orderNUmber)
        let viewModel = OrderTrackingViewModel(useCase: useCase)
//        viewModel.orderNavigation = navigationFlow
        viewModel.navigationDelegate = navigationDelegate
        let viewController = OrderTrackingViewController.create()
        viewController.viewModel = viewModel
        
        return viewController
    }
}
