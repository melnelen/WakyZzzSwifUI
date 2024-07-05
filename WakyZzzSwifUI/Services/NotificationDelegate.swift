//
//  NotificationDelegate.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import Foundation
import UserNotifications
import SwiftUI

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
                    AlarmManager.shared.snoozeAlarm(alarm: alarm) { showKindness in
                        if showKindness {
                            DispatchQueue.main.async {
                                self.alarmToSnooze = alarm
                                self.presentRandomActOfKindnessAlert(alarm: alarm)
                            }
                        }
                    }
                }
            }
        } else {
            NotificationCenter.default.post(name: Notification.Name("AlarmTriggered"), object: response.notification.request.identifier)
        }
        completionHandler()
    }
    
    private func presentRandomActOfKindnessAlert(alarm: Alarm) {
        guard let randomTask = AlarmManager.shared.randomActsOfKindness.randomElement() else { return }
        
        let alert = UIAlertController(title: "Random Act of Kindness", message: randomTask, preferredStyle: .alert)
        
        let completeAction = UIAlertAction(title: "Complete Task", style: .default) { _ in
            self.completeRandomActOfKindness()
        }
        
        let laterAction = UIAlertAction(title: "Promise to Do It Later", style: .cancel) { _ in
            self.promiseToDoItLater()
        }
        
        alert.addAction(completeAction)
        alert.addAction(laterAction)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func completeRandomActOfKindness() {
        // Code to mark the task as completed
        print("Random act of kindness completed.")
    }
    
    private func promiseToDoItLater() {
        // Code to set up a local notification reminder
        print("Promised to do the random act of kindness later.")
    }
}
