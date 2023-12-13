//
//  File.swift
//
//
//  Created by Ahmed Naguib on 01/12/2023.
//

import Foundation
import Combine

protocol ChangeTypeUseCaseProtocol {
    func changeType(orderId: String, orderNumber: String) -> AnyPublisher<ChangeTypeUseCase.State, Never>
}

final class ChangeTypeUseCase: ChangeTypeUseCaseProtocol {
    
    // MARK: - Properties
    private let services: OrderTrackingServiceHandlerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(services: OrderTrackingServiceHandlerProtocol) {
        self.services = services
    }
    
    // MARK: - Functions
    func changeType(orderId: String, orderNumber: String) -> AnyPublisher<State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else {
                return
            }
            self.services.changeOrderType(orderId: orderId)
                .sink { completion in
                    if case .failure(let error) = completion {
                        promise(.success(.showError(message: error.localizedDescription)))
                    }
                } receiveValue: { response in
                    if let isChangeType = response.isChangeType, isChangeType {
                        promise(.success(.navigateToOrderConfirmation(orderId: orderId, orderNumber: orderNumber)))
                    } else {
                        promise(.success(.callOrderStatus))
                    }
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
        
    }
}

extension ChangeTypeUseCase {
    enum State: Equatable {
        case showError(message: String)
        case navigateToOrderConfirmation(orderId: String, orderNumber: String)
        case callOrderStatus
    }
}
