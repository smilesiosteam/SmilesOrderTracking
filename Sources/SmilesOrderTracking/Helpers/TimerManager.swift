//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 14/12/2023.
//

import Foundation

protocol TimerManagerProtocol {
    func start(stopTimerAfter: TimeInterval? ,tickHandler: (() -> Void)?)
    func pause()
    func resume()
    func stop()
}

final class TimerManager: TimerManagerProtocol {
    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0
    private var isTimerRunning = false
    private var timerTickHandler: (() -> Void)?
    private var stopTimerAfter: TimeInterval?
    
    func start(stopTimerAfter: TimeInterval? ,tickHandler: (() -> Void)?) {
        guard timer == nil else { return }

        timerTickHandler = tickHandler
        self.stopTimerAfter = stopTimerAfter
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        isTimerRunning = true
    }

    @objc private func timerTick() {
        elapsedTime += 1
        
        if let stopTimerAfter, elapsedTime >= stopTimerAfter {
            stop()
            timerTickHandler?()
        }
    }

    func pause() {
        guard isTimerRunning else { return }

        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }

    func resume() {
        guard !isTimerRunning else { return }

        start(stopTimerAfter: nil, tickHandler: timerTickHandler)
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        elapsedTime = 0
        isTimerRunning = false
    }
}
