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
                        AlarmRow(viewModel: AlarmRowViewModel(alarm: alarm))
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
                Alert(
                    title: Text("Alarm"),
                    message: Text("Time to wake up!"),
                    primaryButton: .default(Text("Snooze")) {
                        if let alarmID = viewModel.activeAlarmID, let alarm = viewModel.alarmManager.alarms.first(where: { $0.id.uuidString == alarmID }) {
                            viewModel.snoozeAlarm(alarm: alarm)
                        }
                        viewModel.activeAlarmID = nil
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct AlarmsView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmsView(notificationDelegate: NotificationDelegate())
            .environmentObject(NotificationDelegate())
    }
}
