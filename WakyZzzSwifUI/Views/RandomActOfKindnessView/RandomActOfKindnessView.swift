//
//  RandomActOfKindnessView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI

/// A view to display a random act of kindness prompt to the user.
struct RandomActOfKindnessView: View {
    /// The view model managing the state and behavior of the random act of kindness.
    @StateObject private var viewModel = RandomActOfKindnessViewModel()
    /// A binding to control the visibility of this view.
    @Binding var showingView: Bool
    /// The task to be displayed for the random act of kindness.
    let task: String
    /// A state variable to control the display of confetti animation.
    @State private var showConfetti = false
    /// A state variable to control the display of a confirmation message.
    @State private var showMessage = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Random Act of Kindness")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding()
            
            Text(task)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Complete Task") {
                withAnimation {
                    showConfetti = true
                    showMessage = true
                }
                // Hide the view and confetti after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation {
                        showingView = false
                        showConfetti = false
                    }
                }
                print("Random act of kindness completed.")
            }
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Button("Promise to Do It Later") {
                viewModel.scheduleNotification(for: task)
                withAnimation {
                    showingView = false
                }
                print("Promised to do the random act of kindness later.")
            }
        }
        .padding()
        .overlay(
            // Overlay for confetti animation
            ZStack {
                if showConfetti {
                    ForEach(0..<50, id: \.self) { i in
                        ConfettiView()
                            .frame(width: 10, height: 10)
                            .position(
                                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                            )
                    }
                }
            }
        )
        .overlay(
            // Overlay for confirmation message
            ConfirmationMessageView(showMessage: $showMessage, message: "Well done! Keep spreading kindness.")
        )
    }
}

struct RandomActOfKindnessView_Previews: PreviewProvider {
    @State static var showingView = true
    static var previews: some View {
        RandomActOfKindnessView(showingView: $showingView, task: "Message a friend asking how they are doing")
    }
}
