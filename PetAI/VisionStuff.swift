//
//  VisionStuff.swift
//  PetAI
//
//  Created by Carlos Mbendera on 04/04/2025.
//

import AVFoundation
import UIKit
import Vision

// Extension to handle video data output and process it using Vision.
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        // Vision request to detect human body poses.
        let bodyPoseRequest = VNDetectHumanBodyPoseRequest()
        
        // Optional: Set maximum number of people to detect if needed
        // bodyPoseRequest.maximumObjectCount = 1
        
        var bodyPoints: [CGPoint] = []

        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])

        do {
            try handler.perform([bodyPoseRequest])
            guard let observations = bodyPoseRequest.results, !observations.isEmpty else {
                DispatchQueue.main.async {
                    self.bodyPosePointsHandler?([])
                }
                return
            }

            // Process the first detected body
            guard let observation = observations.first else { return }

            // Get all body points
            let points = try observation.recognizedPoints(.all)

            // Filter points with good confidence and convert coordinates
            let validPoints = points.filter { $0.value.confidence > 0.5 }
                .map { CGPoint(x: $0.value.location.x, y: 1 - $0.value.location.y) }

            DispatchQueue.main.async {
                self.bodyPosePointsHandler?(Array(validPoints))
            }

        } catch {
            cameraFeedSession?.stopRunning()
        }
    }
}
