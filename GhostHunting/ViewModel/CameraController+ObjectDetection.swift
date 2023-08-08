//
//  MLController.swift
//  MLImageTesting
//
//  Created by dary winata nugraha djati on 30/07/23.
//

import Vision
import UIKit

extension CameraController {
    func drawBoundingBox(_ bounds: CGRect) -> CALayer {
        let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 4.0
        boxLayer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        boxLayer.cornerRadius = 3
        
        return boxLayer
    }
    
    func setupModel(_ cvPixelBuffer: CVPixelBuffer) {
        guard let modelUrl = Bundle.main.url(forResource: "yolov8x", withExtension: "mlmodelc") else {return}
        do {
            let model = try VNCoreMLModel(for: MLModel(contentsOf: modelUrl))
            let recognition = VNCoreMLRequest(model: model, completionHandler: didSuccessfullyHandled)
            
            recognition.imageCropAndScaleOption = .scaleFill
            
            var orientation : UInt32 = 1
            
            switch cameraOrientation {
            case .portrait:
                orientation = ImageOrientation.portrait.rawValue
            case .landscapeLeft:
                orientation = ImageOrientation.landscapeLeft.rawValue
            case .portraitUpsideDown:
                orientation = ImageOrientation.portraitUpsideDown.rawValue
            case .landscapeRight:
                orientation = ImageOrientation.landscapeRight.rawValue
            default:
                print("error getting orientation")
            }
            
            guard let imageOrientation = CGImagePropertyOrientation(rawValue: orientation) else {return}
            
            self.request = recognition
            let handler = VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer, orientation: imageOrientation)
            try? handler.perform([request])
        } catch {
            print("error when modelling data")
        }
    }
    
    func didSuccessfullyHandled(_ request: VNRequest, error: Error?) {
            self.mlLayer.sublayers = nil
        
        
        for observation in request.results! where observation is VNRecognizedObjectObservation {
            guard let objectObservation  = observation as? VNRecognizedObjectObservation else {return}
            
            let objectBound = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(self.screenSize.width), Int(self.screenSize.height))
            let transformation = CGRect(x: objectBound.minX, y: (screenSize.height-objectBound.maxY), width: abs(objectBound.minX - objectBound.maxX), height: abs(objectBound.minY - objectBound.maxY))

            DispatchQueue.main.async {
                let boxLayer = self.drawBoundingBox(transformation)
                self.mlLayer.addSublayer(boxLayer)
            }
            
        }
    }
}
