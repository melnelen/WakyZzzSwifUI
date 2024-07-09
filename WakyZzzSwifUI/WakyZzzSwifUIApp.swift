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
    @StateObject private var notificationDelegate = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            AlarmsView(notificationDelegate: notificationDelegate, alarmManager: AlarmManager())
                .environmentObject(notificationDelegate)
                .onAppear {
                    UNUserNotificationCenter.current().delegate = notificationDelegate
                    requestNotificationPermissions()
                    configureNotificationActions()
                }
                .sheet(isPresented: $notificationDelegate.showRandomActOfKindness) {
                    RandomActOfKindnessView(showingView: $notificationDelegate.showRandomActOfKindness, task: notificationDelegate.randomActTask)
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
