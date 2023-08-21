//
//  CameraController+ObjectDetection.swift
//  GhostHunting
//
//  Created by dary winata nugraha djati on 09/08/23.
//

import Vision
import ARKit
import RealityKit

extension CameraController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if !isGhostRendered {
            DispatchQueue.global(qos: .userInteractive).async {
                self.handlerForModel(frame.capturedImage)
            }
        }
        
        if isGhostRendered {
            anchorCamera = AnchorEntity(.camera)
            let translation = SIMD3<Float>(x: currentGhost.transform.translation.x, y: cameraTransform.translation.y - 0.15,
                                           z: currentGhost.transform.translation.z)
            currentGhost.look(at: translation, from: currentGhost.position(relativeTo: nil), relativeTo: nil)
//            let transform = Transform()
//            let ghostPosition = Transform(scale: [0.1, 0.1, 0.1], rotation: currentGhost.orientation, translation: SIMD3<Float>(x: frame.camera.transform[3].x, y: frame.camera.transform[3].y, z: frame.camera.transform[3].z-1))
//            ghostPosition.translation = SIMD3<Float>(x: frame.camera.transform[3].x, y: frame.camera.transform[3].y, z: frame.camera.transform[3].z)
//            let xPosition = currentGhost.transform.translation.x > frame.camera.transform[3].x ? currentGhost.transform.translation.x - 0.01 : currentGhost.transform.translation.x + 0.01
            let zPosition = currentGhost.transform.translation.z > (frame.camera.transform[3].z + 0.2) ? currentGhost.transform.translation.z - 0.01 : currentGhost.transform.translation.z + 0.01
            let yPosition = currentGhost.transform.translation.y > (frame.camera.transform[3].y) ? currentGhost.transform.translation.y - 0.01 : currentGhost.transform.translation.y + 0.01
            
            let value = currentGhost.position.z.distance(to: frame.camera.transform[3].z)
            
            if value >= 0.5 {
                if currentGhostName == "Wraith" {
                    currentGhost.position = SIMD3<Float>(x: currentGhost.position.x,
                                                         y: yPosition,
                                                         z: zPosition)
                } else {
                    currentGhost.position = SIMD3<Float>(x: currentGhost.position.x,
                                                         y: currentGhost.position.y,
                                                         z: zPosition)
                }
                
                audioPlayback?.gain = 50 / abs(Double(value))
            }
            
        }
    }
}
