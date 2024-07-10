//
//  ConfirmationMessageView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 10/07/2024.
//

import SwiftUI

struct ConfirmationMessageView: View {
    @Binding var showMessage: Bool
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
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
