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
import AVFAudio

class CameraController : ARView {
    
    var requestObjectDetection : VNRequest = VNRequest()
    var currentGhost: Entity = Entity()
    var currentGhostName: String = ""
    var ghostYawRotation : Float = 0.0
    var screenSize : CGRect = CGRect()
    var ghostTimer : Timer = Timer()
    var ghostWalkCount : Int = 0
    var isGhostRendered = false
    var ghostPoint : CGPoint?
    var ghostCount : Int = 0
    var timerCount : Int = 0
    @Published var isCaptured : Bool = false
    
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
        
//        runTimerGhostApper()
        
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
        if Int.random(in: 1...2) == 1 {
            currentGhostName = "Wraith"
        } else {
            currentGhostName = "Banshee"
        }
        guard let ghostPath = Bundle.main.url(forResource: currentGhostName, withExtension: "usdz") else {return}
        isGhostRendered = true
        DispatchQueue.main.async {
            do  {
                self.currentGhost = try Entity.load(contentsOf: ghostPath)
                self.ghostYawRotation = .pi
                self.currentGhost.transform = Transform(yaw: self.ghostYawRotation)
                let randomPosition = Int.random(in: 1...2)
                self.currentGhost.position = SIMD3<Float>(x: self.currentGhost.position.x,
                                                          y: self.currentGhost.position.y,
                                                          z: randomPosition == 1 ? self.currentGhost.position.z - 10 : self.currentGhost.position.z + 10)
                self.currentGhost.scale *= 0.1
                anchorEntity.addChild(self.currentGhost)
                self.currentGhost.availableAnimations.forEach {
                    self.currentGhost.playAnimation($0.repeat())
                }

                self.scene.addAnchor(anchorEntity)

                let audioGhost = try AudioFileResource.load(named: "\(self.currentGhostName).mp3", inputMode: .spatial, loadingStrategy: .preload, shouldLoop: true)
            
                let audioPlayback = self.currentGhost.prepareAudio(audioGhost)
                audioPlayback.gain = 100
                audioPlayback.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func isGhostVisible() {
        guard let point = self.project(currentGhost.position) else {return}
        if self.bounds.contains(point) && currentGhost.position.z < 0 {
            print("visible")
        } else {
            print("not visible")
        }
    }
    
    func takeAPic() {
        isCaptured = true
    }
    
//    func lightningSetup() {
//        lightningSpotlight.light.color = .yellow
//        lightningSpotlight.light.intensity = 1000000
//        lightningSpotlight.light.innerAngleInDegrees = 40
//        lightningSpotlight.light.attenuationRadius = 10
//        lightningSpotlight.light.outerAngleInDegrees = 60
//        lightningSpotlight.shadow = SpotLightComponent.Shadow()
//    }
}
