//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 01/12/2023.
//

import Foundation
import Combine
import SmilesUtilities

protocol OrderConfirmationUseCaseProtocol {
    func setOrderConfirmation(orderId: String,
                              orderStatus: OrderTrackingType,
                              isUserDeliveredOrder: Bool) -> AnyPublisher<OrderConfirmationUseCase.State, Never>
}

final class OrderConfirmationUseCase: OrderConfirmationUseCaseProtocol {
    
    // MARK: - Properties
    private let services: OrderTrackingServiceHandlerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(services: OrderTrackingServiceHandlerProtocol) {
        self.services = services
    }
    
    // MARK: - Functions
    func setOrderConfirmation(orderId: String,
                              orderStatus: OrderTrackingType,
                              isUserDeliveredOrder: Bool) -> AnyPublisher<State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else {
                return
            }
            self.services.setOrderConfirmationStatus(orderId: orderId, orderStatus: orderStatus)
                .sink { completion in
                    if  case .failure(let error) = completion {
                        promise(.success(.showError(message: error.localizedDescription)))
                    }
                } receiveValue: { response in
                    if let responseCode = response.responseCode, !responseCode.isEmpty {                        promise(.success(.showError(message: response.responseMsg ?? "")))
                    } else {
                        let state: State = isUserDeliveredOrder ? .callOrderStatus : .openLiveChat
                        promise(.success(state))
                    }
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
}

extension OrderConfirmationUseCase {
    enum State: Equatable {
        case showError(message: String)
        case openLiveChat
        case callOrderStatus
    }
}
