//
//  CameraController.swift
//  MLImageTesting
//
//  Created by dary winata nugraha djati on 29/07/23.
//

import SwiftUI
import UIKit
import Vision
import AVFoundation

class CameraController : UIViewController {
    private let cameraQueue : DispatchQueue = DispatchQueue.init(label: "camera_queue")
    private var cameraLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    private var cameraSession : AVCaptureSession = AVCaptureSession()
    private var videoOutput : AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    private var isAuthorized: Bool = false
    var screenSize : CGRect = CGRect()
    var mlLayer : CALayer = CALayer()
    var request : VNRequest = VNRequest()
    var image : UIImage? = nil
    var cameraOrientation : UIDeviceOrientation = .portrait
    
    override func viewDidLoad() {
        cameraPermission()
        
        cameraQueue.async {
            guard self.isAuthorized else {return}
            self.cameraSetup()
            self.cameraSession.startRunning()
        }
    }
    
    func cameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isAuthorized = true
        case .notDetermined:
            authorizedCamera()
        default:
            print("please accept the camera request")
        }
    }
    
    func authorizedCamera() {
        cameraQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { _ in
            self.isAuthorized = true
            self.cameraQueue.resume()
        }
    }
    
    func cameraSetup() {
        guard let cameraDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else {return}
        
        gettingTheOrientation()
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: cameraDevice) else {return}
        guard cameraSession.canAddInput(deviceInput) else {return}
        cameraSession.addInput(deviceInput)
        videoOutput.setSampleBufferDelegate(self, queue: self.cameraQueue)
        guard cameraSession.canAddOutput(videoOutput) else {return}
        cameraSession.addOutput(videoOutput)
        cameraSession.commitConfiguration()

        cameraLayer = AVCaptureVideoPreviewLayer(session: cameraSession)
        cameraLayer.frame = screenSize
        cameraLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        
        mlLayer = CALayer()
        mlLayer.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        
        DispatchQueue.main.async { [self] in
            self.view.layer.addSublayer(self.cameraLayer)
            self.view.layer.addSublayer(mlLayer)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        gettingTheOrientation()
    }
    
    func gettingTheOrientation() {
        screenSize = UIScreen.main.bounds
        cameraLayer.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        
        cameraOrientation = UIDevice.current.orientation
        
        switch cameraOrientation {
        case .portraitUpsideDown:
            cameraLayer.connection?.videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            cameraLayer.connection?.videoOrientation = .landscapeRight
        case .landscapeRight:
            cameraLayer.connection?.videoOrientation = .landscapeLeft
        case .portrait:
            cameraLayer.connection?.videoOrientation = .portrait
        default:
            print("video orientation is not found")
        }
                
        mlLayer.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
    }
}
