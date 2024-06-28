//
//  AlarmRowView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

struct AlarmRowView: View {
    var alarm: Alarm
    var toggleEnabled: (Bool) -> Void

    var body: some View {
        HStack {
            Text(alarm.time, style: .time)
            Spacer()
            Toggle(isOn: Binding(
                get: { alarm.isEnabled },
                set: { newValue in
                    toggleEnabled(newValue)
                }
            )) {
                Text(alarm.isEnabled ? "Enabled" : "Disabled")
            }
        }
    }
}

#Preview {
    AlarmRowView(alarm: Alarm(time: Date(), isEnabled: true), toggleEnabled: { _ in })
}
