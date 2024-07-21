//
//  AlarmToggleView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

/// A view that provides a toggle switch to enable or disable an alarm.
struct AlarmToggleView: View {
    /// The binding to the alarm's enabled state.
    @Binding var isEnabled: Bool

    var body: some View {
        // Toggle switch to enable or disable the alarm.
        Toggle(isOn: $isEnabled) {
            // Label text that changes based on the toggle's state.
            Text(isEnabled ? "Enabled" : "Disabled")
        }
        // Action to perform when the toggle's state changes.
        .onChange(of: isEnabled) { _, newValue in
            // Update the isEnabled state with the new value.
            isEnabled = newValue
        }
    }
}

#Preview {
    AlarmToggleView(isEnabled: .constant(true))
}
