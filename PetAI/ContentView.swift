//
//  ContentView.swift
//  PetAI
//
//  Created by Carlos Mbendera on 04/04/2025.
//

import SwiftUI
import Vision

struct ContentView: View {
    @State private var detectedPoints: [CGPoint] = []
    @State private var viewSize: CGSize = .zero

    private var pointsView: some View {
        ForEach(detectedPoints.indices, id: \.self) { index in
            let pointWork = detectedPoints[index]
            let screenSize = UIScreen.main.bounds.size
            
            let _ = print(pointWork.x)
            let _ = print(pointWork.y)
            
            // Use x for x and y for y, just scaled to screen dimensions
            let point = CGPoint(x: pointWork.y * screenSize.width,
                                y: pointWork.x * screenSize.height)

            Circle()
                .fill(.orange)
                .frame(width: 15)
                .position(x: point.x, y: point.y)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                CameraView { points in
                    detectedPoints = points
                }

                pointsView

            }
        }
        .navigationTitle("PetAI")
        .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    ContentView()
}
