//
//  File.swift
//
//
//  Created by Ahmed Naguib on 06/12/2023.
//

import Foundation
import Combine

protocol PauseOrderUseCaseProtocol {
    func pauseOrder(orderId: String) -> AnyPublisher<PauseOrderUseCase.State, Never>
}

final class PauseOrderUseCase: PauseOrderUseCaseProtocol {
    
    //MARK: - Properties
    private let services: OrderTrackingServiceHandlerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(services: OrderTrackingServiceHandlerProtocol) {
        self.services = services
    }
    
    // MARK: - Functions
    func pauseOrder(orderId: String) -> AnyPublisher<State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else {
                return
            }
            self.services.pauseOrder(orderId: orderId)
                .sink { completion in
                    if case .failure(let error) = completion {
                        promise(.success(.showError(message: error.localizedDescription)))
                    }
                } receiveValue: { response in
                    promise(.success(.presentPopupCancelFlow))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
        
    }
}

extension PauseOrderUseCase {
    enum State: Equatable {
        case showError(message: String)
        case presentPopupCancelFlow
    }
}
