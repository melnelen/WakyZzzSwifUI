//
//  AlarmsView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI

struct AlarmsView: View {
    @State private var alarms: [Alarm] = []
    @State private var showingAddAlarmView = false
    @State private var selectedAlarm: Alarm?
    @State private var showingEditAlarmView = false
    
    @EnvironmentObject var notificationDelegate: NotificationDelegate
    
    var body: some View {
        NavigationView {
            List {
                ForEach(alarms) { alarm in
                    Button(action: {
                        self.selectedAlarm = alarm
                        self.showingEditAlarmView = true
                    }) {
                        AlarmRow(alarm: alarm)
                    }
                }
                .onDelete(perform: deleteAlarm)
            }
            .navigationTitle("Alarms")
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    showingAddAlarmView = true
                }) {
                    Image(systemName: "plus")
                }
                Button(action: {
                    scheduleTestAlarm()
                }) {
                    Text("Test Alarm")
                }
            })
            .sheet(isPresented: $showingAddAlarmView) {
                AddAlarmView(alarms: $alarms)
            }
            .sheet(item: $selectedAlarm) { alarm in
                EditAlarmView(alarms: $alarms, alarm: alarm)
            }
            .onChange(of: notificationDelegate.alarmToSnooze) {
                if let alarm = notificationDelegate.alarmToSnooze {
                    AlarmManager.shared.snoozeAlarm(alarm: alarm)
                    // Clear the alarmToSnooze after handling
                    notificationDelegate.alarmToSnooze = nil
                }
            }
        }
    }
    
    private func deleteAlarm(at offsets: IndexSet) {
        alarms.remove(atOffsets: offsets)
        offsets.forEach { index in
            if index < alarms.count {
                let alarm = alarms[index]
                AlarmManager.shared.removeAlarm(alarm)
            }
        }
    }
    
    private func scheduleTestAlarm() {
        let now = Date()
        let testAlarmTime = Calendar.current.date(byAdding: .minute, value: 1, to: now) ?? now
        let testAlarm = Alarm(time: testAlarmTime, repeatDays: [], isEnabled: true)
        alarms.append(testAlarm)
        AlarmManager.shared.addAlarm(testAlarm)
    }
    
    private func snoozeAlarm(_ alarm: Alarm) {
        AlarmManager.shared.snoozeAlarm(alarm: alarm)
    }
}

struct AlarmRow: View {
    var alarm: Alarm
    
    var body: some View {
        HStack {
            Text(alarm.time, style: .time)
            Spacer()
            Toggle(isOn: .constant(alarm.isEnabled)) {
                Text("Enabled")
            }
        }
    }
}

struct AlarmsView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmsView()
    }
}
