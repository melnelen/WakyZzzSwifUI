//
//  AlarmListView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

struct AlarmListView: View {
    @ObservedObject var viewModel: AlarmsViewModel

        var body: some View {
            List {
                ForEach(viewModel.alarmManager.alarms) { alarm in
                    Button(action: {
                        viewModel.selectedAlarm = alarm
                        viewModel.showingEditAlarmView = true
                    }) {
                        AlarmRowView(alarm: alarm, toggleEnabled: { isEnabled in
                            viewModel.toggleEnabled(for: alarm, isEnabled: isEnabled)
                        })
                    }
                }
                .onDelete(perform: viewModel.deleteAlarm)
            }
        }
}

#Preview {
    AlarmListView(viewModel: AlarmsViewModel(notificationDelegate: NotificationDelegate(), alarmManager: MockAlarmManager()))
}
