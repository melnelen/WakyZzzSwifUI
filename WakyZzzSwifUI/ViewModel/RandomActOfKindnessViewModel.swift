//
//  RandomActOfKindnessViewModel.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 10/07/2024.
//

import SwiftUI
import UserNotifications

class RandomActOfKindnessViewModel: ObservableObject {
    @Published var showingView: Bool = false
    @Published var task: String = ""
    
    func scheduleNotification(for task: String) {
        // Request notification permissions
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                // Create notification content
                let content = UNMutableNotificationContent()
                content.title = "Random Act of Kindness Reminder"
                content.body = task
                content.sound = UNNotificationSound.default
                content.userInfo = ["task": task] // Include task info
                
                // Trigger notification after 1 second for testing
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                
                // Create the request
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
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission denied.")
            }
        }
    }
}
