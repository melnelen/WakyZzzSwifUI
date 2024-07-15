//
//  AlarmsView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI

/// A view that displays a list of alarms and provides functionality to add, edit, and delete alarms.
struct AlarmsView: View {
    /// The view model that manages the state and behavior of the alarms.
    @StateObject private var viewModel: AlarmsViewModel
    
    /// Initializes the view with a notification delegate and an alarm manager.
    /// - Parameters:
    ///   - notificationManager: The notification manager to handle notification-related tasks.
    ///   - alarmManager: The alarm manager to handle alarm-related tasks.
    init(notificationManager: NotificationManager, alarmManager: AlarmManagerProtocol = AlarmManager.shared) {
        _viewModel = StateObject(wrappedValue: AlarmsViewModel(notificationManager: notificationManager, alarmManager: alarmManager))
    }
    
    var body: some View {
        NavigationView {
            AlarmListView(viewModel: viewModel)
            // Set the title of the navigation bar
            .navigationTitle("Alarms")
            // Add buttons to the navigation bar
            .navigationBarItems(trailing: NavigationBarButtonsView(viewModel: viewModel))
            .sheet(isPresented: $viewModel.showingAddAlarmView) {
                // Show the add alarm view as a sheet
                AddAlarmView(alarms: $viewModel.alarms, isPresented: $viewModel.showingAddAlarmView)
            }
            .sheet(item: $viewModel.selectedAlarm) { alarm in
                // Show the edit alarm view as a sheet
                EditAlarmView(alarms: $viewModel.alarms, alarm: alarm, alarmManager: viewModel.alarmManager)
            }
            .alert(isPresented: $viewModel.showingAlarmAlert) {
                // Show an alert for the alarm
                viewModel.alarmAlert
            }
        }
        .onAppear {
            viewModel.updateAlarms()
        }
    }
}

#Preview {
    // Preview provider to display the view in Xcode's canvas
    AlarmsView(notificationManager: NotificationManager(), alarmManager: MockAlarmManager())
        .environmentObject(NotificationManager())
}
