//
//  Counter.swift
//  war_cards_game
//
//  Created by דניאל בן אבי on 25/06/2024.
//

import Foundation

// Define the protocol for updating the UI
protocol CounterDelegate {
    func cb_updateCounterLabel(with count: Int)
    func cb_autoPlayer()
}

// Define the Counter class
class Counter {
    var delegate: CounterDelegate?
    var timer: Timer?
    var counter = 0
    var isPaused = false

    
    func startCounter() {
        if !isPaused {
            counter = 0
        }
        stopCounter()
        timer = Timer.scheduledTimer(timeInterval: TIME_COUNT, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: TIME_INTERVAL_ACTION, target: self, selector: #selector(autoPlayer), userInfo: nil, repeats: true)
    }
    
    func stopCounter() {
        timer?.invalidate()
        timer = nil
        isPaused = false
    }
    
    @objc private func updateCounter() {
        if isPaused {
            return
        }
        counter += 1
        delegate?.cb_updateCounterLabel(with: counter)
    }
    
    @objc func autoPlayer() {
        delegate?.cb_autoPlayer()
    }
    
    func pauseCounter() {
        print("Counter paused")
        timer?.invalidate()
        timer = nil
        isPaused = true
    }
    
    func resumeCounter() {
        print("Counter resumed")
        startCounter()
    }
    
}

