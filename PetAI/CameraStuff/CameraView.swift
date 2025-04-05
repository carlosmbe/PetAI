//
//  CameraView.swift.swift
//  PetAI
//
//  Created by Carlos Mbendera on 04/04/2025.
//

import SwiftUI

// A SwiftUI view that represents a `CameraViewController`.
struct CameraView: UIViewControllerRepresentable {

    // A closure that processes an array of CGPoint values.
    var BodyPosePointsProcessor: (([CGPoint]) -> Void)

    // Initializer that accepts a closure
    init(_ processor: @escaping ([CGPoint]) -> Void) {
        self.BodyPosePointsProcessor = processor
    }

    // Create the associated `UIViewController` for this SwiftUI view.
    func makeUIViewController(context: Context) -> CameraViewController {
        let camViewController = CameraViewController()
        camViewController.bodyPosePointsHandler = BodyPosePointsProcessor
        return camViewController
    }

    // Update the associated `UIViewController` for this SwiftUI view.
    // Currently not implemented as we don't need it for this app.
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) { }
}
