//
//  NavigationBarButtonsView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

struct NavigationBarButtonsView: View {
    @ObservedObject var viewModel: AlarmsViewModel

    var body: some View {
        HStack {
            // Button to schedule a test alarm
            Button(action: {
                viewModel.scheduleTestAlarm()
            }) {
                Image(systemName: "alarm")
                Text("Test Alarm")
            }
            .accessibilityLabel("Schedule a test alarm")

            Divider()
                .frame(height: 20)
                .background(Color.blue)
                .padding(.horizontal, 8)
            
            // Button to show the add alarm view
            Button(action: {
                viewModel.showingAddAlarmView = true
            }) {
                Image(systemName: "plus")
            }
            .accessibilityLabel("Add new alarm")
        }
    }
}

#Preview {
    NavigationBarButtonsView(viewModel: AlarmsViewModel(notificationManager: NotificationManager(), alarmManager: MockAlarmManager()))
}
