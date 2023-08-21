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
    
    @objc dynamic var isCaptured : Bool = false
    
    var requestObjectDetection : VNRequest = VNRequest()
    var audioPlayback : AudioPlaybackController?
    var anchorGhost : AnchorEntity = AnchorEntity()
    var anchorCamera: AnchorEntity = AnchorEntity()
    var currentGhost: Entity = Entity()
    var screenSize : CGRect = CGRect()
    var ghostTimer : Timer = Timer()
    var ghostYawRotation : Float = 0.0
    var currentGhostName: String = ""
    var objectTimerCount : Int = 0
    var ghostWalkCount : Int = 0
    var isGhostRendered = false
    var ghostPoint : CGPoint?
    var ghostCount : Int = 0
    var timerCount : Int = 0
    var objectCount: Int = 0
    
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
        
        runTimerSurroundObject()
        
        self.session.delegate = self

//        self.environment.sceneUnderstanding.options = []
//
//        self.environment.sceneUnderstanding.options.insert(.occlusion)
//        self.environment.sceneUnderstanding.options.insert(.physics)
//        self.renderOptions = [.disablePersonOcclusion, .disableDepthOfField, .disableMotionBlur]
//
//        self.automaticallyConfigureSession = false
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.sceneReconstruction = .meshWithClassification
//
//        configuration.environmentTexturing = .automatic
//        self.session.run(configuration)
        
        anchorCamera = AnchorEntity(.camera)
        self.scene.addAnchor(anchorCamera)
        
        playCameraAudio()
    }
    
    func convertRealCoordinateToWorld() {
        if ghostPoint != nil && isGhostRendered == false {
            if let result = self.raycast(from: ghostPoint!, allowing: .estimatedPlane, alignment: .horizontal).first {
                createGhost(result)
            }
        }
        
    }
    
    func createGhost(_ raycast: ARRaycastResult) {
        anchorGhost = AnchorEntity(world: raycast.worldTransform)
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
                if self.currentGhostName == "Wraith" {
                    self.ghostYawRotation = .pi
                    self.currentGhost.transform = Transform(yaw: self.ghostYawRotation)
                }
                let randomPosition = Int.random(in: 1...2)
                self.currentGhost.position = SIMD3<Float>(x: self.currentGhost.position.x,
                                                          y: self.currentGhostName == "Wraith" ? self.currentGhost.position.y - 3 : self.currentGhost.position.y,
                                                          z: randomPosition == 1 ? self.currentGhost.position.z - 15 : self.currentGhost.position.z + 15)
                self.currentGhost.scale *= 0.1
                self.anchorGhost.addChild(self.currentGhost)
                self.currentGhost.availableAnimations.forEach {
                    self.currentGhost.playAnimation($0.repeat())
                }

                self.scene.addAnchor(self.anchorGhost)

                let audioGhost = try AudioFileResource.load(named: "\(self.currentGhostName).mp3", inputMode: .spatial, loadingStrategy: .preload, shouldLoop: true)
            
                self.audioPlayback = self.currentGhost.prepareAudio(audioGhost)
                self.audioPlayback?.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func isGhostVisible() -> Bool {
        guard let point = self.project(currentGhost.position) else {
            print("point not found")
            
            return false
        }
        
        if self.bounds.contains(point) {
            return true
        } else {
            return false
        }
    }
    
    func takeAPic() {
        if isGhostVisible() {
            isCaptured = true
            self.scene.removeAnchor(anchorGhost)
            runTimerGhostApper()
        }
    }
    
    func randomObjectPlacement() {
        let anchorEntity = AnchorEntity(plane: .horizontal)
        var objectName = ""
        switch Int.random(in: 1...3) {
        case 1:
            objectName = "Blood"
        case 2:
            objectName = "Bone"
        default:
            objectName = "Skull"
        }
        
        guard let ghostPath = Bundle.main.url(forResource: objectName, withExtension: "usdz") else {return}
        
        DispatchQueue.main.async {
            do  {
                let entity = try Entity.load(contentsOf: ghostPath)
                entity.scale *= 0.08
                anchorEntity.addChild(entity)

                self.scene.addAnchor(anchorEntity)

            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func playCameraAudio() {
        guard let bgAudioUrl = Bundle.main.url(forResource: "CameraBgSound", withExtension: "mp3") else {return}
        do {
            let bgAudio = try AVAudioPlayer(contentsOf: bgAudioUrl)
            bgAudio.volume = 1.0
            bgAudio.play()
        } catch {
            print(error.localizedDescription)
        }
    }
}
