//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 18/12/2023.
//

import Foundation
import Combine
@testable import SmilesOrderTracking

final class OrderConfirmationUseCaseMock: OrderConfirmationUseCaseProtocol {
    
    var orderConfirmationResponse: Result<OrderConfirmationUseCase.State, Never> = .success(.callOrderStatus)
    func setOrderConfirmation(orderId: String,
                              orderStatus: OrderTrackingType,
                              isUserDeliveredOrder: Bool) -> AnyPublisher<OrderConfirmationUseCase.State, Never> {
        
        Future<OrderConfirmationUseCase.State, Never> { promise in
            promise(self.orderConfirmationResponse)
        }.eraseToAnyPublisher()
        
    }
}
