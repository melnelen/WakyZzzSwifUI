//
//  AlarmsViewModel.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

class AlarmsViewModel: ObservableObject {
    @Published var alarms: [Alarm] = []
    @Published var showingAddAlarmView = false
    @Published var selectedAlarm: Alarm?
    @Published var showingEditAlarmView = false
    @Published var showingAlarmAlert = false
    @Published var activeAlarmID: String?
    @Published var showRandomActOfKindness = false
    @Published var randomActTask = "Do something kind!"
    
    var notificationManager: NotificationManager
    var alarmManager: AlarmManagerProtocol
    
    var alarmAlert: Alert {
        Alert(
            title: Text("Alarm"),
            message: Text("Time to wake up!"),
            primaryButton: .default(Text("Snooze")) {
                if let alarmID = self.activeAlarmID, let alarm = self.alarms.first(where: { $0.id.uuidString == alarmID }) {
                    self.snoozeAlarm(alarm: alarm)
                }
            },
            secondaryButton: .cancel(Text("Stop")) {
                if let alarmID = self.activeAlarmID, let _ = self.alarms.first(where: { $0.id.uuidString == alarmID }) {
                    self.activeAlarmID = nil
                }
            }
        )
    }
    
    init(notificationManager: NotificationManager, alarmManager: AlarmManagerProtocol = AlarmManager.shared) {
        self.notificationManager = notificationManager
        self.alarmManager = alarmManager
        self.alarms = alarmManager.alarms
        NotificationCenter.default.addObserver(forName: Notification.Name("AlarmTriggered"), object: nil, queue: .main) { notification in
            if let alarmID = notification.object as? String {
                self.activeAlarmID = alarmID
                self.showingAlarmAlert = true
            }
        }
        NotificationCenter.default.addObserver(forName: Notification.Name("ShowRandomActOfKindnessAlert"), object: nil, queue: .main) { notification in
            self.randomActTask = alarmManager.randomActsOfKindness.randomElement() ?? "Do something kind!"
            self.showRandomActOfKindness = true
        }
    }
    
    func deleteAlarm(at offsets: IndexSet) {
        offsets.forEach { index in
            let alarm = alarms[index]
            alarmManager.removeAlarm(alarm)
        }
        updateAlarms()
    }
    
    func scheduleTestAlarm() {
        let now = Date()
        let testAlarmTime = Calendar.current.date(byAdding: .second, value: 1, to: now) ?? now
        let testAlarm = Alarm(time: testAlarmTime, repeatDays: [], isEnabled: true)
        alarmManager.addAlarm(testAlarm)
        updateAlarms()
        print("Scheduled test alarm for 1 second later with ID: \(testAlarm.id)")
    }
    
    func snoozeAlarm(alarm: Alarm) {
        alarmManager.snoozeAlarm(alarm: alarm) { showKindness in
            if showKindness {
                self.randomActTask = self.alarmManager.randomActsOfKindness.randomElement() ?? "Do something kind!"
                self.showRandomActOfKindness = true
            }
        }
        updateAlarms()
    }
    
    func toggleEnabled(for alarm: Alarm, isEnabled: Bool) {
        var updatedAlarm = alarm
        updatedAlarm.isEnabled = isEnabled
        alarmManager.updateAlarm(alarm: updatedAlarm)
        updateAlarms()
    }
    
    func updateAlarms() {
        self.alarms = alarmManager.alarms
    }
}
