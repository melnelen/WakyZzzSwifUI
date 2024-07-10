//
//  ConfettiView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 10/07/2024.
//

import SwiftUI

struct ConfettiView: View {
    var body: some View {
        ZStack {
            ForEach(0..<10) { _ in
                ConfettiParticle()
            }
        }
    }
}

private struct ConfettiParticle: View {
    @State private var xOffset = CGFloat.random(in: -10...10)
    @State private var yOffset = CGFloat.random(in: 0...100)
    @State private var rotation = Angle.degrees(Double.random(in: -30...30))
    @State private var scale = CGFloat.random(in: 0.5...1.5)
    
    var body: some View {
        Image(systemName: "hexagon.fill")
            .font(.system(size: 15))
            .foregroundColor(.random)
            .offset(x: xOffset, y: yOffset)
            .rotationEffect(rotation)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: Double.random(in: 0.5...1.5))
                        .repeatForever(autoreverses: false)
                ) {
                    xOffset = CGFloat.random(in: -100...100)
                    yOffset = CGFloat.random(in: -600...0)
                    rotation = Angle.degrees(Double.random(in: -30...30))
                    scale = CGFloat.random(in: 0.5...1.5)
                }
            }
    }
}

extension Color {
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
