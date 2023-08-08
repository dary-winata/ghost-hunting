//
//  CameraViewRepresentable.swift
//  GhostHunting
//
//  Created by dary winata nugraha djati on 08/08/23.
//

import SwiftUI

struct CameraViewRepresentable : UIViewControllerRepresentable {
    
    let cameraController = CameraController()
    
    func makeUIViewController(context: Context) -> UIViewController {
        return cameraController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
}
