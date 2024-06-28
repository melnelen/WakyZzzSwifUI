//
//  NotificationDelegate.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import Foundation
import UserNotifications

class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    @Published var alarmToSnooze: Alarm?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification will present: \(notification.request.identifier)")
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification received with identifier: \(response.notification.request.identifier)")
        if response.actionIdentifier == "SNOOZE_ACTION" {
            let alarmID = response.notification.request.identifier
            if let alarmUUID = UUID(uuidString: alarmID) {
                if let alarm = AlarmManager.shared.getAlarm(by: alarmUUID) {
                    AlarmManager.shared.snoozeAlarm(alarm: alarm)
                    self.alarmToSnooze = alarm
                }
            }
        } else {
            NotificationCenter.default.post(name: Notification.Name("AlarmTriggered"), object: response.notification.request.identifier)
        }
        completionHandler()
    }
}
