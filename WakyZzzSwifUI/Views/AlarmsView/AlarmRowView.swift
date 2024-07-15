//
//  AlarmRowView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

/// A view that represents a single row for an alarm in the alarm list.
struct AlarmRowView: View {
    @ObservedObject var viewModel: AlarmsViewModel
    var alarm: Alarm
    @State private var isEnabled: Bool

    init(viewModel: AlarmsViewModel, alarm: Alarm) {
        self.viewModel = viewModel
        self.alarm = alarm
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
                    viewModel.toggleEnabled(for: alarm, isEnabled: newValue)
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
    let mockNotificationManager = NotificationManager()
    let mockAlarmManager = MockAlarmManager()

    // Preview for AlarmRowView with sample data
    return AlarmRowView(viewModel: AlarmsViewModel(notificationManager: mockNotificationManager, alarmManager: mockAlarmManager), alarm: sampleAlarm)
}
