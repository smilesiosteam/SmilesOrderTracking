//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 18/12/2023.
//

import Foundation
import Combine
@testable import SmilesOrderTracking

final class ChangeTypeUseCaseMock: ChangeTypeUseCaseProtocol {
    var changeTypeUseCaseResponse: Result<ChangeTypeUseCase.State, Never> = .success(.callOrderStatus)
   
    func changeType(orderId: String, orderNumber: String) -> AnyPublisher<ChangeTypeUseCase.State, Never> {
        Future<ChangeTypeUseCase.State, Never> { promise in
            promise(self.changeTypeUseCaseResponse)
        }.eraseToAnyPublisher()
    }
}
