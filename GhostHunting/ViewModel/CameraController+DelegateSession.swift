//
//  CameraController+ObjectDetection.swift
//  GhostHunting
//
//  Created by dary winata nugraha djati on 09/08/23.
//

import Vision
import ARKit

extension CameraController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if !isGhostRendered {
            DispatchQueue.global(qos: .userInteractive).async {
                self.handlerForModel(frame.capturedImage)
            }
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        
    }
}
