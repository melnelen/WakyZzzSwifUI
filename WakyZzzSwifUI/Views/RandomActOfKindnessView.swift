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
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Random Act of Kindness")
                .font(.largeTitle)
                .padding()
            
            Text(task)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Complete Task") {
                showingView = false
                // Code to mark the task as completed
            }
            
            Button("Promise to Do It Later") {
                showingView = false
                // Code to set up a local notification reminder
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .padding()
    }
}

struct RandomActOfKindnessView_Previews: PreviewProvider {
    @State static var showingView = true
    static var previews: some View {
        RandomActOfKindnessView(showingView: $showingView, task: "Message a friend asking how they are doing")
    }
}
