//
//  File.swift
//
//
//  Created by Ahmed Naguib on 30/11/2023.
//

import Foundation
import UIKit
import Combine
import NetworkingLayer
import SmilesUtilities

public struct OrderTrackingDependance {
    public var orderId: String
    public var orderNUmber: String
    public var checkForVoucher: Bool
    public var chatbotType: String
    public var isCameFromMyOrder = false
    public var personalizationEventSource: String?
    
    public init(orderId: String, orderNUmber: String, checkForVoucher: Bool = false, chatbotType: String) {
        self.orderId = orderId
        self.orderNUmber = orderNUmber
        self.checkForVoucher = checkForVoucher
        self.chatbotType = chatbotType
    }
}

public struct GetSupportDependance {
    public var orderId: String
    public var orderNUmber: String
    public var chatBotType:String
    
    public init(orderId: String, orderNumber: String, chatbotType: String) {
        self.orderId = orderId
        self.orderNUmber = orderNumber
        self.chatBotType = chatbotType
    }
}

public enum TrackOrderConfigurator {
    
    public static func getOrderTrackingView(dependance: OrderTrackingDependance,
                                            navigationDelegate: OrderTrackingNavigationProtocol,
                                            firebasePublisher: AnyPublisher<LiveTrackingState, Never>
    ) -> OrderTrackingViewController {
        let useCase = OrderTrackingUseCase(orderId: dependance.orderId,
                                           orderNumber: dependance.orderNUmber,
                                           services: service, timer: TimerManager())
        let orderConfirmationUseCase = OrderConfirmationUseCase(services: service)
        let changeTypeUseCase = ChangeTypeUseCase(services: service)
        let scratchAndWinUseCase = ScratchAndWinUseCase()
        let useCasePauseOrder = PauseOrderUseCase(services: service)
        let viewModel = OrderTrackingViewModel(useCase: useCase, confirmUseCase: orderConfirmationUseCase, changeTypeUseCase: changeTypeUseCase, scratchAndWinUseCase: scratchAndWinUseCase, firebasePublisher: firebasePublisher, pauseOrderUseCase: useCasePauseOrder)
        viewModel.navigationDelegate = navigationDelegate
        viewModel.orderId = dependance.orderId
        viewModel.orderNumber = dependance.orderNUmber
        viewModel.checkForVoucher = dependance.checkForVoucher
        viewModel.chatbotType = dependance.chatbotType
        viewModel.personalizationEventSource = dependance.personalizationEventSource
        let viewController = OrderTrackingViewController.create()
        viewController.viewModel = viewModel
        viewController.isCameFromMyOrder = dependance.isCameFromMyOrder
        return viewController
    }
    
    static func getConfirmationPopup(locationText: String, didTappedContinue: (()-> Void)?) -> UIViewController {
        let viewController = PickupConfirmationViewController.create()
        viewController.locationText = locationText
        viewController.didTappedContinue = didTappedContinue
        return viewController
    }
    
    static var service: OrderTrackingServiceHandler {
        return .init(repository: repository)
    }
    
    static var network: Requestable {
        NetworkingLayerRequestable(requestTimeOut: 60)
    }
    
    static var repository: OrderTrackingServiceable {
        OrderTrackingRepository(networkRequest: network)
    }
    
    
    public static func getOrderSupportView(dependance: GetSupportDependance,
                                           navigationDelegate: OrderTrackingNavigationProtocol?) -> UIViewController {
        let useCase = GetSupportUseCase(orderId: dependance.orderId,
                                        orderNumber: dependance.orderNUmber,
                                        services: service)
        let viewModel = GetSupportViewModel(useCase: useCase, orderId: dependance.orderId, orderNumber: dependance.orderNUmber,chatBotType: dependance.chatBotType)
        viewModel.navigationDelegate = navigationDelegate
        let viewController = GetSupportViewController.create()
        viewController.viewModel = viewModel
        return viewController
    }
    
}
