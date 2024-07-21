//
//  Alarm.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import Foundation

/// A struct representing an alarm.
struct Alarm: Identifiable, Codable, Equatable {
    
    /// Conformance to `Equatable` to compare two `Alarm` instances.
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.id == rhs.id
    }
    
    /// Unique identifier for the alarm.
    var id: UUID
    /// The time the alarm is set to go off.
    var time: Date
    /// The days on which the alarm should repeat.
    var repeatDays: [String]
    /// A flag indicating whether the alarm is enabled.
    var isEnabled: Bool
    /// The number of times the alarm has been snoozed.
    var snoozeCount: Int
    
    /// Initializes a new `Alarm` instance.
    /// - Parameters:
    ///   - id: The unique identifier for the alarm. Default is a new UUID.
    ///   - time: The time the alarm is set to go off. Default is the current date and time.
    ///   - repeatDays: The days on which the alarm should repeat. Default is an empty array.
    ///   - isEnabled: A flag indicating whether the alarm is enabled. Default is `true`.
    ///   - snoozeCount: The number of times the alarm has been snoozed. Default is `0`.
    init(id: UUID = UUID(), time: Date = Date(), repeatDays: [String] = [], isEnabled: Bool = true, snoozeCount: Int = 0) {
        self.id = id
        self.repeatDays = repeatDays
        self.isEnabled = isEnabled
        self.snoozeCount = snoozeCount
        
        // Set default time to 8 AM the next day if the provided time is invalid
        if time <= Date.distantPast {
            var components = DateComponents()
            components.hour = 8
            components.minute = 0
            var defaultTime = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            defaultTime = Calendar.current.nextDate(after: defaultTime, matching: components, matchingPolicy: .nextTime) ?? defaultTime
            self.time = defaultTime
        } else {
            self.time = time
        }
    }
    
    /// A static example of an `Alarm` for preview purposes.
    static var example: Alarm {
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let alarmTime = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: tomorrow)!
        
        return Alarm(time: alarmTime, repeatDays: ["Monday", "Wednesday", "Friday"], isEnabled: true, snoozeCount: 0)
    }
}
