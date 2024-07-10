//
//  RandomActOfKindnessView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI

struct RandomActOfKindnessView: View {
    @Binding var showingView: Bool
    let task: String
    @State private var showConfetti = false
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
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
                withAnimation {
                    showingView = false
                }
                // Code to set up a local notification reminder
                print("Promised to do the random act of kindness later.")
            }
        }
        .padding()
        .overlay(
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
