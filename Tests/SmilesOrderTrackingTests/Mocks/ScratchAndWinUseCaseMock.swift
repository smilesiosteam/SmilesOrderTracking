//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 18/12/2023.
//

import Foundation
import Combine
@testable import SmilesOrderTracking

final class ScratchAndWinUseCaseMock: ScratchAndWinUseCaseProtocol {
    private var stateSubject = PassthroughSubject<ScratchAndWinUseCase.State, Never>()
    
    var statePublisher: AnyPublisher<ScratchAndWinUseCase.State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    func configureScratchAndWin(with orderId: String, isVoucherScratched: Bool) {
        
    }
}
