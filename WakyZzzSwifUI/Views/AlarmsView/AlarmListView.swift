//
//  AlarmListView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

/// A view that displays a list of alarms.
struct AlarmListView: View {
    @ObservedObject var viewModel: AlarmsViewModel

    var body: some View {
        List {
            // Iterate over each alarm in the view model's alarms list
            ForEach(viewModel.alarms) { alarm in
                // Button to handle alarm row tap action
                Button(action: {
                    // Set the selected alarm and show the edit alarm view
                    viewModel.selectedAlarm = alarm
                    viewModel.showingEditAlarmView = true
                }) {
                    // Use the AlarmRowView to display each alarm row
                    AlarmRowView(viewModel: viewModel, alarm: alarm)
                    .accessibilityLabel("Alarm set for \(alarm.time, style: .time)")
                    .accessibilityHint("Double tap to edit alarm")
                }
            }
            // Enable deletion of alarms
            .onDelete(perform: viewModel.deleteAlarm)
        }
    }
}

#Preview {
    // Preview for AlarmListView with mock data
    AlarmListView(viewModel: AlarmsViewModel(notificationManager: NotificationManager(), alarmManager: MockAlarmManager()))
}
