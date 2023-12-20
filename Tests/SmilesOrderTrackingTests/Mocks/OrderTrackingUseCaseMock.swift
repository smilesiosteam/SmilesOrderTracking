//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 18/12/2023.
//

import Foundation
import Combine
@testable import SmilesOrderTracking

final class OrderTrackingUseCaseMock: OrderTrackingUseCaseProtocol {
    // MARK: - Properties
    var stateSubject = PassthroughSubject<OrderTrackingUseCase.State, Never>()
    var isCalledPauseTimer = false
    var isCalledResumeTimer = false
    var isCalledFetchOrderStates = false
    var statePublisher: AnyPublisher<OrderTrackingUseCase.State, Never>{
        stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Functions
    func fetchOrderStates() {
        isCalledFetchOrderStates.toggle()
    }
    
    func loadOrderStatus(orderId: String, orderStatus: String, orderNumber: String, isComingFromFirebase: Bool) {
        
    }
    
    func pauseTimer() {
        isCalledPauseTimer.toggle()
    }
    
    func resumeTimer() {
        isCalledResumeTimer.toggle()
    }
}
