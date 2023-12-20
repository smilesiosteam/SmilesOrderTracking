//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 18/12/2023.
//

import Foundation
import Combine
@testable import SmilesOrderTracking

final class PauseOrderUseCaseMock: PauseOrderUseCaseProtocol {
    
    var pauseOrderResponse: Result<PauseOrderUseCase.State, Never> = .success(.presentPopupCancelFlow)
    
    func pauseOrder(orderId: String) -> AnyPublisher<PauseOrderUseCase.State, Never> {
        Future<PauseOrderUseCase.State, Never> { promise in
            promise(self.pauseOrderResponse)
        }.eraseToAnyPublisher()
    }
}
