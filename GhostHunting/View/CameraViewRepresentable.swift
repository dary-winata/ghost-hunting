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
    
    var cameraController : CameraController = CameraController()
    var cancellable = Set<AnyCancellable>()
    @State var isGhostCaptured : Bool = false

    func makeUIView(context: Context) -> ARView {
        bindingCameraVariable()
        
        return cameraController
    }

    func updateUIView(_ uiView: ARView, context: Context) {

    }
    
    func bindingCameraVariable() {
        let _ = cameraController
            .publisher(for: \.isCaptured)
            .sink { newValue in
//                isGhostCaptured = newValue
                print("new :", newValue)
            } receiveValue: { value in
                print("get value : ", value)
            }
    }
    
    func pickPhotoGhost() {
        cameraController.takeAPic()
    }
    
    typealias UIViewType = ARView
}


