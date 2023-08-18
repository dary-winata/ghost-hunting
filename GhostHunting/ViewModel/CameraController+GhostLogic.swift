//
//  CameraController+GhostLogic.swift
//  GhostHunting
//
//  Created by dary winata nugraha djati on 11/08/23.
//

import Foundation

extension CameraController {
    func runTimerGhostApper() {
        ghostCount = Int.random(in: 15..<76)
        
        timerCount = 0
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerGhostApper), userInfo: nil, repeats: true)
    }
    
    @objc func timerGhostApper(timer: Timer) {
        if timerCount == ghostCount {
            isGhostRendered = false
            timer.invalidate()
        }
        
        if isGhostRendered {
            timerCount += 1
        }
    }
}
