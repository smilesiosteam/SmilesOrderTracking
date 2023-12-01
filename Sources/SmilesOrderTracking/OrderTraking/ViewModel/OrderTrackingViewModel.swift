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
    private let useCase: OrderTrackingUseCaseProtocol
    private var statusSubject = PassthroughSubject<State, Never>()
    var orderId = ""
    var orderStatusPublisher: AnyPublisher<State, Never> {
        statusSubject.eraseToAnyPublisher()
    }
    
    var orderNavigation: ((OrderTrackingNavigation) -> Void) = { _ in }
    var navigationDelegate: OrderTrackingNavigationProtocol?
    // MARK: - Init
    init(useCase: OrderTrackingUseCaseProtocol) {
        self.useCase = useCase
       
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
