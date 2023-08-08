//
//  CameraController+VideoDelegate.swift
//  MLImageTesting
//
//  Created by dary winata nugraha djati on 31/07/23.
//

import AVFoundation

extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func videoCapture(didCaptureVideoFrame pixelBuffer: CVPixelBuffer?) {
        self.setupModel(pixelBuffer!)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        videoCapture(didCaptureVideoFrame: imageBuffer)
    }
}
