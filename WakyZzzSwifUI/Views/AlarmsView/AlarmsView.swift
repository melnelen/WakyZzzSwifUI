//
//  AlarmsView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI

struct AlarmsView: View {
    @StateObject private var viewModel: AlarmsViewModel
    
    init(notificationDelegate: NotificationManager, alarmManager: AlarmManagerProtocol) {
        _viewModel = StateObject(wrappedValue: AlarmsViewModel(notificationDelegate: notificationDelegate, alarmManager: alarmManager))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.alarms) { alarm in
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
            .navigationTitle("Alarms")
            .navigationBarItems(trailing: NavigationBarButtonsView(viewModel: viewModel))
            .sheet(isPresented: $viewModel.showingAddAlarmView) {
                AddAlarmView(alarms: $viewModel.alarms, isPresented: $viewModel.showingAddAlarmView)
            }
            .sheet(item: $viewModel.selectedAlarm) { alarm in
                EditAlarmView(alarms: $viewModel.alarms, alarm: alarm, notificationDelegate: viewModel.notificationDelegate)
            }
            .alert(isPresented: $viewModel.showingAlarmAlert) {
                viewModel.alarmAlert
            }
        }
    }
}

#Preview {
    AlarmsView(notificationDelegate: NotificationManager(), alarmManager: MockAlarmManager())
        .environmentObject(NotificationManager())
}
