//
//  NotificationManager.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import UserNotifications
import SwiftUI

/// A class that manages notifications for the WakyZzzSwifUI app.
class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    // Alarm to be snoozed
    @Published var alarmToSnooze: Alarm?
    // Flag to show the random act of kindness view
    @Published var showRandomActOfKindness: Bool = false
    // The task for the random act of kindness
    @Published var randomActTask: String = ""
    
    // Shared instance of the AlarmManager
    let alarmManager = AlarmManager.shared
    
    /// Initializes the NotificationManager and sets up the notification center delegate and observer for random act of kindness alerts.
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(showRandomActOfKindnessAlert(_:)), name: Notification.Name("ShowRandomActOfKindnessAlert"), object: nil)
    }
    
    /// Shows a random act of kindness alert when the corresponding notification is received.
    /// - Parameter notification: The notification object containing the alert details.
    @objc private func showRandomActOfKindnessAlert(_ notification: Notification) {
        randomActTask = alarmManager.randomActsOfKindness.randomElement() ?? "Do something kind!"
        showRandomActOfKindness = true
    }
    
    /// Handles the presentation of notifications while the app is in the foreground.
    /// - Parameters:
    ///   - center: The notification center.
    ///   - notification: The notification to be presented.
    ///   - completionHandler: The completion handler to execute with the presentation options.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification will present: \(notification.request.identifier)")
        completionHandler([.banner, .sound])
    }
    
    /// Handles the response to a delivered notification.
    /// - Parameters:
    ///   - center: The notification center.
    ///   - response: The user's response to the notification.
    ///   - completionHandler: The completion handler to execute when the action is complete.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification received with identifier: \(response.notification.request.identifier)")
        
        if let task = response.notification.request.content.userInfo["task"] as? String {
            randomActTask = task
            showRandomActOfKindness = true
        }
        
        NotificationCenter.default.post(name: Notification.Name("AlarmTriggered"), object: response.notification.request.identifier)
        completionHandler()
    }
}
