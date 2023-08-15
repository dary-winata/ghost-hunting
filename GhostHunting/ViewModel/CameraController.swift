//
//  CameraController.swift
//  GhostHunting
//
//  Created by dary winata nugraha djati on 09/08/23.
//

import RealityKit
import ARKit
import CoreML
import UIKit

class CameraController : ARView {
    
    var requestObjectDetection : VNRequest = VNRequest()
    var screenSize : CGRect = CGRect()
    var ghostPoint : CGPoint?
    var ghostTimer : Int = 0
    var isGhostRendered = false
    var timerCount : Int = 0
    var currentGhost: ModelEntity = ModelEntity()
    
    var dataModel : MLModel = {
        do {
            guard let url = Bundle.main.url(forResource: "yolov8x", withExtension: "mlmodelc") else {return MLModel()}
            return try MLModel(contentsOf: url)
        } catch {
            fatalError("Dataset not defined")
        }
    }()
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        
        screenSize = UIScreen.main.bounds
                
        setupModelSession()
        
        runTimerGhostApper()
        
        self.session.delegate = self

        self.environment.sceneUnderstanding.options = []
        
        self.environment.sceneUnderstanding.options.insert(.occlusion)
        self.environment.sceneUnderstanding.options.insert(.physics)
        self.renderOptions = [.disablePersonOcclusion, .disableDepthOfField, .disableMotionBlur]
        
        self.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.sceneReconstruction = .meshWithClassification

        configuration.environmentTexturing = .automatic
        self.session.run(configuration)
    }
    
    func convertRealCoordinateToWorld() {
        if ghostPoint != nil && isGhostRendered == false {
            if let result = self.raycast(from: ghostPoint!, allowing: .estimatedPlane, alignment: .horizontal).first {
                createGhost(result)
            }
        }
        
    }
    
    func createGhost(_ raycast: ARRaycastResult) {
        let anchorEntity = AnchorEntity(world: raycast.worldTransform)
        isGhostRendered = true
        DispatchQueue.main.async {
            do  {
                let entity = try Botak.loadHantu()
                self.currentGhost = entity.findEntity(named: "Cube") as! ModelEntity
                self.currentGhost.transform = Transform(yaw: .pi)
                self.currentGhost.scale *= 0.1
                anchorEntity.addChild(self.currentGhost)
                self.scene.addAnchor(anchorEntity)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
