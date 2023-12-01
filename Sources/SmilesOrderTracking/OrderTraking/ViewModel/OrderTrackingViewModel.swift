//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 14/11/2023.
//

import Foundation
import Combine

final class OrderTrackingViewModel {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    var serviceHandler = OrderTrackingServiceHandler()

    private let useCase: OrderTrackingUseCaseProtocol
    private let confirmUseCase: OrderConfirmationUseCaseProtocol
    private var statusSubject = PassthroughSubject<State, Never>()
    var orderId = ""
    var orderStatusPublisher: AnyPublisher<State, Never> {
        statusSubject.eraseToAnyPublisher()
    }
    
    var navigationDelegate: OrderTrackingNavigationProtocol?
    
    // MARK: - Init
    init(useCase: OrderTrackingUseCaseProtocol, confirmUseCase: OrderConfirmationUseCaseProtocol) {
        self.useCase = useCase
        self.confirmUseCase = confirmUseCase
    }
    
    func fetchStatus(with status: Int?) {
        bindUseCase()
        useCase.fetchOrderStates(with: status)
    }
    
    private func bindUseCase() {
        statusSubject.send(.showLoader)
        useCase.statePublisher.sink { [weak self] states in
            guard let self else {
                return
            }
            self.statusSubject.send(.hideLoader)
            switch states {
            case .showError(let message):
                self.statusSubject.send(.showError(message: message))
            case .showToastForArrivedOrder(let isShow):
                self.statusSubject.send(.showToastForArrivedOrder(isShow: isShow))
            case .showToastForNoLiveTracking(let isShow):
                self.statusSubject.send(.showToastForNoLiveTracking(isShow: isShow))
            case .success(let model):
                self.statusSubject.send(.success(model: model))
            case .orderId(let id):
                self.orderId = id
            }
        }
        .store(in: &cancellables)
    }
    
    
    func setConfirmationStatus(orderId: String, orderStatus: OrderTrackingType, isUserDeliveredOrder: Bool, orderNumber: String) {
        statusSubject.send(.showLoader)
        confirmUseCase.setOrderConfirmation(orderId: orderId,
                                            orderStatus: orderStatus,
                                            isUserDeliveredOrder: isUserDeliveredOrder)
        .sink { [weak self] state in
            guard let self else {
                return
            }
            self.statusSubject.send(.hideLoader)
            switch state {
            case .showError(message: let message):
                self.statusSubject.send(.showError(message: message))
            case .openLiveChat:
                self.navigationDelegate?.openLiveChat(orderId: orderId, orderNumber: orderNumber)
            case .callOrderStatus:
                self.fetchStatus(with: nil)
            }
        }
        .store(in: &cancellables)
    }
}

extension OrderTrackingViewModel {
    enum State {
        case showLoader
        case hideLoader
        case showError(message: String)
        case showToastForArrivedOrder(isShow: Bool)
        case showToastForNoLiveTracking(isShow: Bool)
        case success(model: OrderTrackingModel)
    }
}
