//
//  MockAlarmManager.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 10/07/2024.
//

import Foundation

class MockAlarmManager: AlarmManagerProtocol {
    static let shared = MockAlarmManager()
    
    var alarms: [Alarm] = []
    var randomActsOfKindness: [String] = RandomActsOfKindnessLoader.loadRandomActsOfKindness()
    
    func addAlarm(_ alarm: Alarm) {
        alarms.append(alarm)
    }
    
    func removeAlarm(_ alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms.remove(at: index)
        }
    }
    
    func updateAlarm(alarm: Alarm, isEnabled: Bool) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm
            alarms[index].isEnabled = isEnabled
        }
    }
    
    func getAlarm(by id: UUID?) -> Alarm? {
        guard let id = id else { return nil }
        return alarms.first(where: { $0.id == id })
    }
    
    func snoozeAlarm(alarm: Alarm, completion: @escaping (Bool) -> Void) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index].snoozeCount += 1
            if alarms[index].snoozeCount > 2 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func scheduleAlarm(alarm: Alarm) {
        // Mock implementation
        print("Mock: Scheduled alarm with identifier: \(alarm.id)")
    }
    
    func disableAlarm(alarm: Alarm) {
        // Mock implementation
        print("Mock: Disabled alarm with identifier: \(alarm.id)")
    }
    
    func enableAlarm(alarm: Alarm) {
        // Mock implementation
        print("Mock: Enabled alarm with identifier: \(alarm.id)")
    }
}
