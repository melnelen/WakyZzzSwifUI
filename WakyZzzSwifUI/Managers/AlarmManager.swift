//
//  AlarmManager.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI
import UserNotifications

class AlarmManager {
    
    static let shared = AlarmManager()
        
        private init() {}
        
        private var alarms: [Alarm] = []
        
        func addAlarm(_ alarm: Alarm) {
            alarms.append(alarm)
            scheduleAlarm(alarm: alarm)
        }
        
        func updateAlarm(_ alarm: Alarm) {
            if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
                alarms[index] = alarm
                if alarm.isEnabled {
                    enableAlarm(alarm: alarm)
                } else {
                    disableAlarm(alarm: alarm)
                }
            }
        }
        
        func removeAlarm(_ alarm: Alarm) {
            if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
                disableAlarm(alarm: alarm)
                alarms.remove(at: index)
            }
        }
        
        func getAlarm(by id: UUID?) -> Alarm? {
            guard let id = id else { return nil }
            return alarms.first(where: { $0.id == id })
        }
        
        func scheduleAlarm(alarm: Alarm) {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Alarm"
            content.body = "Time to wake up!"
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "ALARM_CATEGORY"
            
            let calendar = Calendar.current
            
            for day in alarm.repeatDays {
                guard let weekday = calendar.weekdaySymbols.firstIndex(of: day) else { continue }
                
                var dateComponents = calendar.dateComponents([.hour, .minute], from: alarm.time)
                dateComponents.weekday = weekday + 1 // Sunday is 1, Monday is 2, etc.
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let identifier = "\(alarm.id)-\(day)"
                
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling alarm: \(error)")
                    }
                }
            }
        }
        
        func disableAlarm(alarm: Alarm) {
            let center = UNUserNotificationCenter.current()
            var identifiers: [String] = []
            
            for day in alarm.repeatDays {
                let identifier = "\(alarm.id)-\(day)"
                identifiers.append(identifier)
            }
            
            center.removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        
        func enableAlarm(alarm: Alarm) {
            disableAlarm(alarm: alarm) // Remove existing notifications
            scheduleAlarm(alarm: alarm) // Schedule new notifications
        }
        
        func snoozeAlarm(alarm: Alarm) {
            // Increment snooze count
            if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
                alarms[index].snoozeCount += 1
            }
            
            // Schedule the next snooze
            let content = UNMutableNotificationContent()
            content.title = "Snooze Alarm"
            content.body = "Time to wake up!"
            content.sound = UNNotificationSound.default // Change this to escalate volume if needed
            content.categoryIdentifier = "ALARM_CATEGORY"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
            let request = UNNotificationRequest(identifier: "\(alarm.id)-snooze", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling snooze alarm: \(error)")
                }
            }
        }
    
    private func playEvilSound(alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Evil Alarm"
        content.body = "You must complete a random act of kindness to turn off this alarm."
        content.sound = UNNotificationSound(named: UNNotificationSoundName("evil_alarm_sound.mp3"))
        content.categoryIdentifier = "ALARM_CATEGORY"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "\(alarm.id)-evil", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling evil alarm: \(error)")
            }
        }
        
        // Present Random Act of Kindness View
        if let randomTask = randomActsOfKindness.randomElement() {
            DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    let rootViewController = window.rootViewController
                    let view = UIHostingController(rootView: RandomActOfKindnessView(showingView: .constant(true), task: randomTask))
                    rootViewController?.present(view, animated: true, completion: nil)
                }
            }
        }
    }
    
    private let randomActsOfKindness: [String] = [
        "Message a friend asking how they are doing",
        "Connect with a family member by expressing a kind thought",
        "Compliment a colleague on their work",
        "Donate to a charity of your choice",
        "Write a positive review for a local business",
        "Offer to help a neighbor with a chore",
        "Leave a positive note for a family member or roommate",
        "Volunteer for a community service activity",
        "Send a thank-you note to someone who has helped you recently",
        "Pay for a stranger’s coffee or meal"
    ]
}
