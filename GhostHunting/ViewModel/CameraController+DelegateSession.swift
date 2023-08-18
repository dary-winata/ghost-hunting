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
            let translation = SIMD3<Float>(x: currentGhost.transform.translation.x, y: cameraTransform.translation.y - 0.15,
                                           z: abs(currentGhost.transform.translation.z-abs(cameraTransform.translation.z) > 0.5 ? cameraTransform.translation.z : currentGhost.transform.translation.z))
//            print(currentGhost.transform.translation)
            currentGhost.look(at: translation, from: currentGhost.position(relativeTo: nil), relativeTo: nil)
//            let transform = Transform()
//            let ghostPosition = Transform(scale: [0.1, 0.1, 0.1], rotation: currentGhost.orientation, translation: SIMD3<Float>(x: frame.camera.transform[3].x, y: frame.camera.transform[3].y, z: frame.camera.transform[3].z-1))
//            ghostPosition.translation = SIMD3<Float>(x: frame.camera.transform[3].x, y: frame.camera.transform[3].y, z: frame.camera.transform[3].z)
            let zPosition = currentGhost.transform.translation.z > (frame.camera.transform[3].z + 0.2) ? currentGhost.transform.translation.z - 0.01 : currentGhost.transform.translation.z + 0.01
            let xPosition = currentGhost.transform.translation.x > frame.camera.transform[3].x ? currentGhost.transform.translation.x - 0.01 : currentGhost.transform.translation.x + 0.01
            let yPosition = currentGhost.transform.translation.y < (frame.camera.transform[3].y + 0.3) ? currentGhost.transform.translation.y + 0.01 : currentGhost.transform.translation.y - 0.01
            currentGhost.position = SIMD3<Float>(x: currentGhost.position.x,
                                                 y: yPosition,
                                                 z: zPosition)
            isGhostVisible()
        }
    }
}
