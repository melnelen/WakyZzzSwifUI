//
//  AlarmsViewModel.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI
import UserNotifications

class AlarmsViewModel: ObservableObject {
    @Published var alarmManager = AlarmManager.shared
    @Published var showingAddAlarmView = false
    @Published var selectedAlarm: Alarm?
    @Published var showingEditAlarmView = false
    @Published var showingAlarmAlert = false
    @Published var activeAlarmID: String?
    
    var notificationDelegate: NotificationDelegate
    
    init(notificationDelegate: NotificationDelegate) {
        self.notificationDelegate = notificationDelegate
        NotificationCenter.default.addObserver(forName: Notification.Name("AlarmTriggered"), object: nil, queue: .main) { notification in
            if let alarmID = notification.object as? String {
                print("Notification received for alarm ID: \(alarmID)")
                self.activeAlarmID = alarmID
                self.showingAlarmAlert = true
            }
        }
    }
    
    func deleteAlarm(at offsets: IndexSet) {
        offsets.forEach { index in
            let alarm = alarmManager.alarms[index]
            alarmManager.removeAlarm(alarm)
        }
    }
    
    func scheduleTestAlarm() {
        let now = Date()
        let testAlarmTime = Calendar.current.date(byAdding: .minute, value: 1, to: now) ?? now
        let testAlarm = Alarm(time: testAlarmTime, repeatDays: [], isEnabled: true)
        alarmManager.addAlarm(testAlarm)
        print("Scheduled test alarm for 1 minute later with ID: \(testAlarm.id)")
        
        // Trigger an immediate notification for testing purposes
        triggerImmediateNotification(for: testAlarm)
    }
    
    func snoozeAlarm(alarm: Alarm) {
        alarmManager.snoozeAlarm(alarm: alarm)
    }
    
    private func triggerImmediateNotification(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Time to wake up!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "ALARM_CATEGORY"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "\(alarm.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling immediate test alarm: \(error)")
            } else {
                print("Immediate test alarm scheduled with identifier: \(alarm.id)")
            }
        }
    }
    
    var alarmAlert: Alert {
        Alert(
            title: Text("Alarm"),
            message: Text("Time to wake up!"),
            primaryButton: .default(Text("Snooze")) {
                if let alarmID = self.activeAlarmID, let alarm = self.alarmManager.alarms.first(where: { $0.id.uuidString == alarmID }) {
                    self.snoozeAlarm(alarm: alarm)
                }
                self.activeAlarmID = nil
            },
            secondaryButton: .cancel()
        )
    }
    
    // Methods from AlarmRowViewModel
    func toggleEnabled(for alarm: Alarm, isEnabled: Bool) {
        var updatedAlarm = alarm
        updatedAlarm.isEnabled = isEnabled
        alarmManager.updateAlarm(updatedAlarm)
    }
}
