//
//  CancelButton.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

/// A button that performs a cancel action, dismissing the current view.
struct CancelButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Cancel").bold()
        }
    }
}

#Preview {
    CancelButton(action: {
        print("Cancel button pressed.")
    })
}
