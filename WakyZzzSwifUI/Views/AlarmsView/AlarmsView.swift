//
//  AlarmsView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI

struct AlarmsView: View {
    @StateObject private var viewModel: AlarmsViewModel
    
    init(notificationDelegate: NotificationDelegate) {
        _viewModel = StateObject(wrappedValue: AlarmsViewModel(notificationDelegate: notificationDelegate))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.alarmManager.alarms) { alarm in
                    Button(action: {
                        self.viewModel.selectedAlarm = alarm
                        self.viewModel.showingEditAlarmView = true
                    }) {
                        AlarmRowView(alarm: alarm) { isEnabled in
                            viewModel.toggleEnabled(for: alarm, isEnabled: isEnabled)
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteAlarm)
            }
            .navigationTitle("Alarms")
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    viewModel.showingAddAlarmView = true
                }) {
                    Image(systemName: "plus")
                }
                Button(action: {
                    viewModel.scheduleTestAlarm()
                }) {
                    Text("Test Alarm")
                }
            })
            .sheet(isPresented: $viewModel.showingAddAlarmView) {
                AddAlarmView(alarms: $viewModel.alarmManager.alarms, isPresented: $viewModel.showingAddAlarmView)
            }
            .sheet(item: $viewModel.selectedAlarm) { alarm in
                EditAlarmView(alarms: $viewModel.alarmManager.alarms, alarm: alarm, notificationDelegate: viewModel.notificationDelegate)
            }
            .alert(isPresented: $viewModel.showingAlarmAlert) {
                viewModel.alarmAlert
            }
        }
    }
}

#Preview {
    AlarmsView(notificationDelegate: NotificationDelegate())
        .environmentObject(NotificationDelegate())
}
