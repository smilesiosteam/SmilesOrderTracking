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
    public var checkForVoucher: Bool
    
    public init(orderId: String, orderNUmber: String, checkForVoucher: Bool = false) {
        self.orderId = orderId
        self.orderNUmber = orderNUmber
        self.checkForVoucher = checkForVoucher
    }
}

public enum TrackOrderConfigurator {
    
    public static func getOrderTrackingView(dependance: OrderTrackingDependance, 
                                            navigationDelegate: OrderTrackingNavigationProtocol) -> UIViewController {
        let useCase = OrderTrackingUseCase(orderId: dependance.orderId, 
                                           orderNumber: dependance.orderNUmber,
                                           services: service)
        let orderConfirmationUseCase = OrderConfirmationUseCase(services: service)
        let changeTypeUseCase = ChangeTypeUseCase(services: service)
        let scratchAndWinUseCase = ScratchAndWinUseCase()
        let viewModel = OrderTrackingViewModel(useCase: useCase, confirmUseCase: orderConfirmationUseCase, changeTypeUseCase: changeTypeUseCase, scratchAndWinUseCase: scratchAndWinUseCase)
        viewModel.navigationDelegate = navigationDelegate
        viewModel.orderId = dependance.orderId
        viewModel.checkForVoucher = dependance.checkForVoucher
        let viewController = OrderTrackingViewController.create()
        viewController.viewModel = viewModel
        return viewController
    }
    
    static func getConfirmationPopup(locationText: String, didTappedContinue: (()-> Void)?) -> UIViewController {
        let viewController = PickupConfirmationViewController.create()
        viewController.locationText = locationText
        viewController.didTappedContinue = didTappedContinue
        return viewController
    }
    
   static var service: OrderTrackingServiceHandler {
        return .init()
    }
}
