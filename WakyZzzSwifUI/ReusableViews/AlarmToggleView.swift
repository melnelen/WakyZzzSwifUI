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
    }
}

#Preview {
    AlarmToggleView(isEnabled: .constant(true))
}
