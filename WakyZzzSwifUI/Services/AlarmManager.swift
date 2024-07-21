//
//  AlarmManager.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI
import UserNotifications

/// `AlarmManager` is a class that manages alarm objects and conforms to the `AlarmManagerProtocol`.
/// It handles the creation, updating, deletion, and scheduling of alarms.
class AlarmManager: ObservableObject, AlarmManagerProtocol {
    // Singleton instance of `AlarmManager`
    static let shared = AlarmManager()
    
    /// Published property to store the list of alarms, which automatically saves alarms when updated.
    @Published var alarms: [Alarm] = [] {
        didSet {
            saveAlarms()
        }
    }
    
    /// List of random acts of kindness loaded from a loader.
    var randomActsOfKindness: [String] = RandomActsOfKindnessLoader.loadRandomActsOfKindness()
    
    private init() {
        // Load alarms when the instance is initialized
        loadAlarms()
    }
    
    /// Key for storing alarms in UserDefaults
    private let userDefaultsKey = "alarms"
    
    /// Adds a new alarm, sorts the alarms, and schedules the alarm.
    /// - Parameter alarm: The alarm to be added.
    func addAlarm(_ alarm: Alarm) {
        if isValidDate(alarm.time) {
            alarms.append(alarm)
            sortAlarms()
            scheduleAlarm(alarm: alarm)
        } else {
            print("Invalid date for alarm: \(alarm.time)")
        }
    }
    
    /// Updates an existing alarm and sorts the alarms.
    /// - Parameter alarm: The alarm to be updated.
    func updateAlarm(alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }), isValidDate(alarm.time) {
            alarms[index] = alarm
            sortAlarms()
        }
    }
    
    /// Removes an alarm from the list and disables it.
    /// - Parameter alarm: The alarm to be removed.
    func removeAlarm(_ alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            disableAlarm(alarm: alarm)
            alarms.remove(at: index)
        }
    }
    
    /// Retrieves an alarm by its unique identifier.
    /// - Parameter id: The UUID of the alarm.
    /// - Returns: The alarm if found, otherwise nil.
    func getAlarm(by id: UUID?) -> Alarm? {
        guard let id = id else { return nil }
        return alarms.first(where: { $0.id == id })
    }
    
    /// Schedules a notification for an alarm.
    /// - Parameter alarm: The alarm to be scheduled.
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
    
    /// Disables a scheduled alarm.
    /// - Parameter alarm: The alarm to be disabled.
    func disableAlarm(alarm: Alarm) {
        let center = UNUserNotificationCenter.current()
        let identifier = "\(alarm.id)"
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    /// Enables a previously scheduled alarm.
    /// - Parameter alarm: The alarm to be enabled.
    func enableAlarm(alarm: Alarm) {
        disableAlarm(alarm: alarm)
        scheduleAlarm(alarm: alarm)
    }
    
    /// Snoozes an alarm and increments its snooze count. If the snooze count reaches 2, it triggers a random act of kindness alert.
    /// - Parameters:
    ///   - alarm: The alarm to be snoozed.
    ///   - completion: Completion handler that indicates whether to show a random act of kindness.
    func snoozeAlarm(alarm: Alarm, completion: @escaping (Bool) -> Void) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index].snoozeCount += 1
            
            if alarms[index].snoozeCount >= 2 {
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
    
    /// Validates if a date is valid (year is greater than 1).
    /// - Parameter date: The date to be validated.
    /// - Returns: True if the date is valid, otherwise false.
    func isValidDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        return components.year! > 1
    }
    
    /// Saves the current list of alarms to UserDefaults.
    func saveAlarms() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(alarms) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    /// Loads the list of alarms from UserDefaults.
    func loadAlarms() {
        if let savedAlarms = UserDefaults.standard.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Alarm].self, from: savedAlarms) {
                alarms = decoded
                sortAlarms()
            }
        }
    }
    
    /// Plays an "evil" sound and schedules a notification to perform a random act of kindness.
    /// - Parameter alarm: The alarm triggering the action.
    func playEvilSound(alarm: Alarm) {
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
    
    /// Sorts the list of alarms by time.
    func sortAlarms() {
        alarms.sort { $0.time.timeInMinutes < $1.time.timeInMinutes }
    }
}

extension Date {
    // Extension property to get the time of the date in minutes.
    var timeInMinutes: Int {
        return Calendar.current.component(.hour, from: self) * 60
        + Calendar.current.component(.minute, from: self)
    }
}
