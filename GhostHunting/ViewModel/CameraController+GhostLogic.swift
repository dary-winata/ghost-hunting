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
    
    func runTimerSurroundObject() {
        objectCount = Int.random(in: 15..<35)
        
        objectTimerCount = 0
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerSurroundObject), userInfo: nil, repeats: true)
    }
    
    @objc func timerSurroundObject(timer: Timer) {
        if objectTimerCount == objectCount {
            randomObjectPlacement()
            objectCount = Int.random(in: 15..<35)
            objectTimerCount = 0
        }
        
        objectTimerCount += 1
    }
}
