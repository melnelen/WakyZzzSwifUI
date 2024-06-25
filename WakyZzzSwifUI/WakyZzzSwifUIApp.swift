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
            AlarmsView()
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
    }
    
    private func configureNotificationActions() {
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",
                                                title: "Snooze",
                                                options: [.foreground]) // Ensure the app opens
        
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
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "SNOOZE_ACTION" {
            // Handle snooze action
            let alarmID = response.notification.request.identifier
            if let alarmUUID = UUID(uuidString: alarmID) {
                if let alarm = AlarmManager.shared.getAlarm(by: alarmUUID) {
                    AlarmManager.shared.snoozeAlarm(alarm: alarm)
                    self.alarmToSnooze = alarm
                }
            }
        }
        completionHandler()
    }
}
