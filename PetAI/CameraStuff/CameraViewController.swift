//
//  CameraViewController.swift
//  PetAI
//
//  Created by Carlos Mbendera on 04/04/2025.
//

import AVFoundation
import UIKit
import Vision

enum CameraErrors: Error {
      case unauthorized, setupError, visionError
}

final class CameraViewController: UIViewController {

    // Queue for processing video data.
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedOutput", qos: .userInteractive)
    var cameraFeedSession: AVCaptureSession?

    //Vision Vars, these are used later
    var bodyPosePointsHandler: (([CGPoint]) -> Void)?

    // On loading, start the camera feed.
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            if cameraFeedSession == nil {
                try setupAVSession()
            }
            //Important: Call this line with DispatchQueue otherwise it will cause a crash
                DispatchQueue.global(qos: .userInteractive).async {
                    self.cameraFeedSession?.startRunning()
            }
        } catch {
            print(error.localizedDescription)
        }
    }


    // On disappearing, stop the camera feed.
    override func viewDidDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewDidDisappear(animated)
    }


    // Setting up the AV session.
    private func setupAVSession() throws {

        //Ask for Camera permission otherwise crash
        if AVCaptureDevice.authorizationStatus(for: .video) != .authorized{
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if !authorized{
                    fatalError("Camera Access is Rquired")
                }
            }
        }

        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            throw CameraErrors.setupError
        }

        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            throw CameraErrors.setupError
        }

        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = .high

        guard session.canAddInput(deviceInput) else {
            throw CameraErrors.setupError
        }

        session.addInput(deviceInput)

        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            throw CameraErrors.setupError
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.bounds

        session.commitConfiguration()
        cameraFeedSession = session
    }

}
