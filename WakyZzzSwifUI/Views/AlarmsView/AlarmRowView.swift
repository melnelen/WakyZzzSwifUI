//
//  AlarmRowView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

/// A view that represents a single row for an alarm in the alarm list.
struct AlarmRowView: View {
    var alarm: Alarm
    var toggleEnabled: (Bool) -> Void
    @State private var isEnabled: Bool

    init(alarm: Alarm, toggleEnabled: @escaping (Bool) -> Void) {
        self.alarm = alarm
        self.toggleEnabled = toggleEnabled
        self._isEnabled = State(initialValue: alarm.isEnabled)
    }

    var body: some View {
        HStack {
            // Display the alarm time
            Text(alarm.time, style: .time)
                .font(.title2)
                .accessibilityLabel("Alarm set for \(alarm.time, style: .time)")
                .accessibilityHint("Displays the alarm time")

            Spacer()

            // Toggle to enable or disable the alarm
            Toggle("", isOn: $isEnabled)
                .onChange(of: isEnabled) { _, newValue in
                    toggleEnabled(newValue)
                }
                .accessibilityLabel(isEnabled ? "Disable alarm" : "Enable alarm")
                .accessibilityHint("Toggle the alarm on or off")
        }
        .padding(5)
    }
}

#Preview {
    // Sample alarm for preview
    let sampleAlarm = Alarm(time: Date(), isEnabled: true)

    // Preview for AlarmRowView with sample data
    return AlarmRowView(alarm: sampleAlarm, toggleEnabled: { _ in })
}
