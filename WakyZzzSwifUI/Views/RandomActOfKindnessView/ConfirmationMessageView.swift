//
//  ConfirmationMessageView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 10/07/2024.
//

import SwiftUI

/// A view that displays a confirmation message with a fade-out animation.
struct ConfirmationMessageView: View {
    /// Binding to control the visibility of the confirmation message.
    @Binding var showMessage: Bool
    /// The message to be displayed.
    let message: String
    
    var body: some View {
        if showMessage {
            Text(message)
                .font(.title)
                .padding(30)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .transition(.opacity)
                .onAppear {
                    // Schedule hiding the message after 4 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            showMessage = false
                        }
                    }
                }
        }
    }
}

struct ConfirmationMessageView_Previews: PreviewProvider {
    @State static var showMessage = true
    static var previews: some View {
        ConfirmationMessageView(showMessage: $showMessage, message: "Well done! Keep spreading kindness.")
    }
}
