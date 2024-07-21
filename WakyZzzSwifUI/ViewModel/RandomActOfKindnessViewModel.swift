//
//  RandomActOfKindnessViewModel.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 10/07/2024.
//

import SwiftUI
import UserNotifications

/// ViewModel for handling the Random Act of Kindness feature.
class RandomActOfKindnessViewModel: ObservableObject {
    @Published var showingView: Bool = false
    @Published var task: String = ""
    
    /// Schedules a notification for the given task.
    /// - Parameter task: The task to be reminded of.
    func scheduleNotification(for task: String) {
        // Request notification permissions from the user
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                // If permission is granted, create the notification content
                let content = UNMutableNotificationContent()
                content.title = "Random Act of Kindness Reminder"
                content.body = task
                content.sound = UNNotificationSound.default
                content.userInfo = ["task": task] // Include task info
                
                // Set a trigger to fire the notification after 1 second (for testing purposes)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                
                // Create the notification request
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                // Add the request to the notification center
                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Notification scheduled for task: \(task)")
                    }
                }
            } else if let error = error {
                // Handle any errors that occurred while requesting permission
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                // Handle the case where the user denied the notification permission
                print("Notification permission denied.")
            }
        }
    }
}
