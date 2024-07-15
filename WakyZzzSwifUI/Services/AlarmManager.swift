//
//  AlarmManager.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI
import UserNotifications

class AlarmManager: ObservableObject, AlarmManagerProtocol {
    static let shared = AlarmManager()
    
    @Published var alarms: [Alarm] = [] {
        didSet {
            saveAlarms()
        }
    }
    
    var randomActsOfKindness: [String] = RandomActsOfKindnessLoader.loadRandomActsOfKindness()
    
    init() {
        loadAlarms()
    }
    
    private let userDefaultsKey = "alarms"
    
    func addAlarm(_ alarm: Alarm) {
        if isValidDate(alarm.time) {
            alarms.append(alarm)
            sortAlarms()
            scheduleAlarm(alarm: alarm)
            print("Added alarm: \(alarm)")
        } else {
            print("Invalid date for alarm: \(alarm.time)")
        }
    }
    
    func updateAlarm(alarm: Alarm, isEnabled: Bool) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }), isValidDate(alarm.time) {
            alarms[index] = alarm
            sortAlarms()
            if isEnabled {
                enableAlarm(alarm: alarm)
            } else {
                disableAlarm(alarm: alarm)
            }
            print("Updated alarm: \(alarm)")
        }
    }
    
    func removeAlarm(_ alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            disableAlarm(alarm: alarm)
            alarms.remove(at: index)
            print("Removed alarm: \(alarm)")
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
        
        let interval = alarm.time.timeIntervalSinceNow
        if interval > 0 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            let identifier = "\(alarm.id)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling alarm: \(error)")
                } else {
                    print("Alarm scheduled with identifier: \(identifier) at time: \(alarm.time)")
                }
            }
        } else {
            print("Invalid interval for alarm: \(interval), current date: \(Date()), alarm time: \(alarm.time)")
        }
    }
    
    func disableAlarm(alarm: Alarm) {
        let center = UNUserNotificationCenter.current()
        let identifier = "\(alarm.id)"
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Disabled alarm: \(alarm)")
    }
    
    func enableAlarm(alarm: Alarm) {
        disableAlarm(alarm: alarm)
        scheduleAlarm(alarm: alarm)
    }
    
    func snoozeAlarm(alarm: Alarm, completion: @escaping (Bool) -> Void) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index].snoozeCount += 1
            
            if alarms[index].snoozeCount > 2 {
                playEvilSound(alarm: alarms[index])
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("ShowRandomActOfKindnessAlert"), object: alarm)
                }
                completion(true)
            } else {
                let content = UNMutableNotificationContent()
                content.title = "Snooze Alarm"
                content.body = "Time to wake up!"
                content.sound = UNNotificationSound.default
                content.categoryIdentifier = "ALARM_CATEGORY"
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // Change time interval for tests
                let request = UNNotificationRequest(identifier: "\(alarm.id)", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling snooze alarm: \(error)")
                    } else {
                        print("Snooze alarm scheduled with identifier: \(alarm.id)")
                    }
                }
                completion(false)
            }
        }
    }
    
    private func isValidDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        return components.year! > 1
    }
    
    private func saveAlarms() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(alarms) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadAlarms() {
        if let savedAlarms = UserDefaults.standard.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Alarm].self, from: savedAlarms) {
                alarms = decoded
                sortAlarms()
            }
        }
    }
    
    private func playEvilSound(alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Evil Alarm"
        content.body = "You must complete a random act of kindness to turn off this alarm."
        content.sound = UNNotificationSound(named: UNNotificationSoundName("sound.mp3"))
        content.categoryIdentifier = "ALARM_CATEGORY"
        
        // Change time interval for tests
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "\(alarm.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling evil alarm: \(error)")
            } else {
                print("Evil alarm scheduled with identifier: \(alarm.id)")
            }
        }
        
        // Present Random Act of Kindness Alert
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("ShowRandomActOfKindnessAlert"), object: alarm)
        }
    }
    
    private func sortAlarms() {
        alarms.sort { $0.time.timeInMinutes < $1.time.timeInMinutes }
    }
}

extension Date {
    var timeInMinutes: Int {
        return Calendar.current.component(.hour, from: self) * 60
        + Calendar.current.component(.minute, from: self)
    }
}
