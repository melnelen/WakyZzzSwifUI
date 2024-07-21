//
//  AlarmsViewModel.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

/// ViewModel for managing the alarms and their interactions within the app.
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
    
    /// Computed property for generating an alert when an alarm is triggered.
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
    
    /// Initializes the ViewModel with notification and alarm managers.
    /// - Parameters:
    ///   - notificationManager: The notification manager to handle notifications.
    ///   - alarmManager: The alarm manager to handle alarm-related tasks.
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
    
    /// Deletes alarms at the specified offsets.
    /// - Parameter offsets: The index set of alarms to delete.
    func deleteAlarm(at offsets: IndexSet) {
        offsets.forEach { index in
            let alarm = alarms[index]
            alarmManager.removeAlarm(alarm)
        }
        updateAlarms()
    }
    
    /// Schedules a test alarm for 1 second later.
    func scheduleTestAlarm() {
        let now = Date()
        let testAlarmTime = Calendar.current.date(byAdding: .second, value: 1, to: now) ?? now
        let testAlarm = Alarm(time: testAlarmTime, repeatDays: [], isEnabled: true)
        alarmManager.addAlarm(testAlarm)
        updateAlarms()
        print("Scheduled test alarm for 1 second later with ID: \(testAlarm.id)")
        
        // Trigger the test alarm notification after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.triggerTestAlarmNotification(alarm: testAlarm)
        }
    }
    
    /// Triggers a test alarm notification.
    /// - Parameter alarm: The alarm to trigger.
    func triggerTestAlarmNotification(alarm: Alarm) {
        if alarm.snoozeCount <= 2 {
            NotificationCenter.default.post(name: Notification.Name("AlarmTriggered"), object: alarm.id.uuidString)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.incrementSnoozeCountAndTrigger(alarm: alarm)
            }
        } else {
            NotificationCenter.default.post(name: Notification.Name("ShowRandomActOfKindnessAlert"), object: alarm)
            if let index = self.alarms.firstIndex(where: { $0.id == alarm.id }) {
                self.alarms[index].snoozeCount = 0
            }
        }
    }
    
    /// Increments the snooze count and triggers the alarm notification again.
    /// - Parameter alarm: The alarm to snooze and trigger.
    private func incrementSnoozeCountAndTrigger(alarm: Alarm) {
        if let index = self.alarms.firstIndex(where: { $0.id == alarm.id }) {
            self.alarms[index].snoozeCount += 1
            self.triggerTestAlarmNotification(alarm: self.alarms[index])
        }
    }
    
    /// Snoozes the specified alarm.
    /// - Parameter alarm: The alarm to snooze.
    func snoozeAlarm(alarm: Alarm) {
        alarmManager.snoozeAlarm(alarm: alarm) { showKindness in
            if showKindness {
                self.randomActTask = self.alarmManager.randomActsOfKindness.randomElement() ?? "Do something kind!"
                self.showRandomActOfKindness = true
            }
        }
        updateAlarms()
    }
    
    /// Toggles the enabled state of the specified alarm.
    /// - Parameters:
    ///   - alarm: The alarm to toggle.
    ///   - isEnabled: The new enabled state.
    func toggleEnabled(for alarm: Alarm, isEnabled: Bool) {
        var updatedAlarm = alarm
        updatedAlarm.isEnabled = isEnabled
        alarmManager.updateAlarm(alarm: updatedAlarm)
        updateAlarms()
    }
    
    /// Updates the list of alarms to reflect the current state in the alarm manager.
    func updateAlarms() {
        self.alarms = alarmManager.alarms
    }
}
