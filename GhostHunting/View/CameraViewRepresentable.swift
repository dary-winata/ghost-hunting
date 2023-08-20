//
//  CameraViewRepresentable.swift
//  GhostHunting
//
//  Created by dary winata nugraha djati on 09/08/23.
//

import ARKit
import SwiftUI
import RealityKit
import Combine

struct CameraViewRepresentable: UIViewRepresentable {
    
    private var cameraController : CameraController = CameraController()
    var cancellable = Set<AnyCancellable>()
    var isGhostCaptured : Bool = false

    func makeUIView(context: Context) -> ARView {
        bindingCameraVariable()
        
        return cameraController
    }

    func updateUIView(_ uiView: ARView, context: Context) {

    }
    
    func bindingCameraVariable() {
//        cameraController.$isCaptured.assign(to: \.isGhostCaptured, on: self)
    }
    
    func pickPhotoGhost() {
        cameraController.takeAPic()
    }
    
    typealias UIViewType = ARView
}


