//
//  WakyZzzSwifUIApp.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI
import UserNotifications

@main
struct WakyZzzSwiftUIApp: App {
    
    @StateObject private var notificationDelegate = NotificationDelegate()
    
    init() {
        requestNotificationPermissions()
        configureNotificationActions()
    }
    
    var body: some Scene {
        WindowGroup {
            AlarmsView(notificationDelegate: notificationDelegate)
                .environmentObject(notificationDelegate)
                .onAppear {
                    UNUserNotificationCenter.current().delegate = notificationDelegate
                }
        }
    }
    
    private func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted")
            } else {
                if let error = error {
                    print("Error requesting notification permissions: \(error)")
                } else {
                    print("Permission denied")
                }
            }
        }
        center.getNotificationSettings { settings in
            print("Notification settings: \(settings)")
        }
    }
    
    private func configureNotificationActions() {
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",
                                                title: "Snooze",
                                                options: [.foreground])
        
        let category = UNNotificationCategory(identifier: "ALARM_CATEGORY",
                                              actions: [snoozeAction],
                                              intentIdentifiers: [],
                                              options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}


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
