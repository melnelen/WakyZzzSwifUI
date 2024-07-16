//
//  AlarmToggleView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

struct AlarmToggleView: View {
    @Binding var isEnabled: Bool

    var body: some View {
        Toggle(isOn: $isEnabled) {
            Text(isEnabled ? "Enabled" : "Disabled")
        }
        .onChange(of: isEnabled) { _, newValue in
            isEnabled = newValue
        }
    }
}

#Preview {
    AlarmToggleView(isEnabled: .constant(true))
}
