//
//  CameraViewRepresentable.swift
//  GhostHunting
//
//  Created by dary winata nugraha djati on 09/08/23.
//

import ARKit
import SwiftUI
import RealityKit

struct CameraViewRepresentable: UIViewRepresentable {
    
    var cameraController : CameraController = CameraController()

    func makeUIView(context: Context) -> ARView {        
        return cameraController
    }

    func updateUIView(_ uiView: ARView, context: Context) {

    }
    
    
    typealias UIViewType = ARView
}


