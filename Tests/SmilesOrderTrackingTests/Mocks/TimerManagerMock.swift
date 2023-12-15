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
    var isCalledPauseTimer = false
    var isCalledResumeTimer = false
    var isCalledStopTimer = false
    
    // MARK: - Functions
    func start(stopTimerAfter: TimeInterval?) {
        isCalledStartTimer.toggle()
    }
    
    func pause() {
        isCalledPauseTimer.toggle()
    }
    
    func resume() {
        isCalledResumeTimer.toggle()
    }
    
    func stop() {
        timerTickHandler?()
        isCalledStopTimer.toggle()
    }
}
