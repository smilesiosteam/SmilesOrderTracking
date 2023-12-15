//
//  File.swift
//
//
//  Created by Ahmed Naguib on 14/12/2023.
//

import Foundation
@testable import SmilesOrderTracking

final class TimerManagerMock: TimerManagerProtocol {
    // MARK: - Spy Properties
    var isCalledStartTimer = false
    var timerTickHandler: (() -> Void)?
    var isRunning = false
    
    // MARK: - Functions
    func start(stopTimerAfter: TimeInterval?) {
        isCalledStartTimer.toggle()
    }
    
    func pause() {
        
    }
    
    func resume() {
        
    }
    
    func stop() {
        timerTickHandler?()
    }
}
