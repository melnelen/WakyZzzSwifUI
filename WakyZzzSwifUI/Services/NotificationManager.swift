//
//  NotificationManager.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import UserNotifications
import SwiftUI

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var alarmToSnooze: Alarm?
    @Published var showRandomActOfKindness: Bool = false
    @Published var randomActTask: String = ""
    
    let alarmManager = AlarmManager.shared
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(showRandomActOfKindnessAlert(_:)), name: Notification.Name("ShowRandomActOfKindnessAlert"), object: nil)
    }
    
    @objc private func showRandomActOfKindnessAlert(_ notification: Notification) {
        randomActTask = alarmManager.randomActsOfKindness.randomElement() ?? "Do something kind!"
        showRandomActOfKindness = true
    }
    
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
        
        if let task = response.notification.request.content.userInfo["task"] as? String {
            randomActTask = task
            showRandomActOfKindness = true
        }
        
        NotificationCenter.default.post(name: Notification.Name("AlarmTriggered"), object: response.notification.request.identifier)
        completionHandler()
    }
}
