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
    
    init(id: UUID = UUID(), time: Date, repeatDays: [String] = [], isEnabled: Bool = true, snoozeCount: Int = 0) {
        self.id = id
        self.time = time
        self.repeatDays = repeatDays
        self.isEnabled = isEnabled
        self.snoozeCount = snoozeCount
    }
}
