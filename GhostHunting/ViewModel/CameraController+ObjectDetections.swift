//
//  CameraController+ObjectDetections.swift
//  GhostHunting
//
//  Created by dary winata nugraha djati on 10/08/23.
//

import Vision
import UIKit

extension CameraController {
    func setupModelSession() {
        guard let model = try? VNCoreMLModel(for: self.dataModel) else {return}
        let recognition = VNCoreMLRequest(model: model, completionHandler: self.didFinishHandling)
        recognition.imageCropAndScaleOption = .scaleFill
        
        self.requestObjectDetection = recognition
    }
    
    func handlerForModel(_ imageBuffer : CVImageBuffer) {
        var orientation : UInt32 = 0
        
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = ImageOrientation.portrait.rawValue
        case .landscapeLeft:
            orientation = ImageOrientation.landscapeLeft.rawValue
        case .portraitUpsideDown:
            orientation = ImageOrientation.portraitUpsideDown.rawValue
        case .landscapeRight:
            orientation = ImageOrientation.landscapeRight.rawValue
        default:
            orientation = 6
        }
        
        guard let imageOrientation = CGImagePropertyOrientation(rawValue: orientation) else {return}
        
        let mlHandler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, orientation: imageOrientation)
        try? mlHandler.perform([self.requestObjectDetection])
    }
    
    func didFinishHandling(_ request: VNRequest, error: Error?) {
        if error != nil {
            return
        }
        
        let listObject : [String] = ["car", "bench", "dining table", "tv", "microwave", "refrigerator"]
        
        if isGhostRendered == false {
            for observation in request.results! where observation is VNRecognizedObjectObservation {
                
                guard let objectObservation  = observation as? VNRecognizedObjectObservation else {return}
//                if listObject.contains(objectObservation.labels.first?.identifier ?? "") {
                    let objectBound = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(self.screenSize.width), Int(self.screenSize.height))
                    
                    let midPointX = (abs(objectBound.minX-objectBound.maxX)/2) + objectBound.minX
                    let midPointY = (abs(objectBound.minY-objectBound.maxY)/2) + objectBound.minY
                    
                    self.ghostPoint = CGPoint(x: midPointX, y: midPointY)
                    self.convertRealCoordinateToWorld()
//                }
            }
        }
        
    }
}
