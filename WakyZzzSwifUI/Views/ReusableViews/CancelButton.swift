//
//  CancelButton.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

/// A button that performs a cancel action, dismissing the current view.
struct CancelButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button("Cancel") {
            print("Cancel button pressed.")
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    CancelButton()
}
