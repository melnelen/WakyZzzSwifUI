//
//  Alarm.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import Foundation

struct Alarm: Identifiable, Codable, Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: UUID
    var time: Date
    var repeatDays: [String]
    var isEnabled: Bool
    var snoozeCount: Int
    
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
