//
//  ConfettiView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 10/07/2024.
//

import SwiftUI

/// A view that displays a confetti effect with multiple confetti particles.
struct ConfettiView: View {
    var body: some View {
        ZStack {
            // Create 10 confetti particles.
            ForEach(0..<10) { _ in
                ConfettiParticle()
            }
        }
    }
}

/// A single confetti particle with random attributes and animations.
private struct ConfettiParticle: View {
    /// Random initial x offset for the particle.
    @State private var xOffset = CGFloat.random(in: -10...10)
    /// Random initial y offset for the particle.
    @State private var yOffset = CGFloat.random(in: 0...100)
    /// Random initial rotation angle for the particle.
    @State private var rotation = Angle.degrees(Double.random(in: -30...30))
    /// Random initial scale for the particle.
    @State private var scale = CGFloat.random(in: 0.5...1.5)
    
    var body: some View {
        Image(systemName: "hexagon.fill")
            .font(.system(size: 15))
            .foregroundColor(.random)
            .offset(x: xOffset, y: yOffset)
            .rotationEffect(rotation)
            .onAppear {
                // Animate the particle with random properties.
                withAnimation(
                    Animation.easeInOut(duration: Double.random(in: 0.5...1.5))
                        .repeatForever(autoreverses: false)
                ) {
                    // Update properties to animate the particle.
                    xOffset = CGFloat.random(in: -100...100)
                    yOffset = CGFloat.random(in: -600...0)
                    rotation = Angle.degrees(Double.random(in: -30...30))
                    scale = CGFloat.random(in: 0.5...1.5)
                }
            }
    }
}

/// An extension to generate a random color.
extension Color {
    /// Generates a random color.
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

#Preview {
    ConfettiView()
}
