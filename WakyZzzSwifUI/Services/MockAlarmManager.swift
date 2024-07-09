//
//  MockAlarmManager.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 10/07/2024.
//

import Foundation

class MockAlarmManager: AlarmManagerProtocol {
    var alarms: [Alarm] = []
    var randomActsOfKindness: [String] = RandomActsOfKindnessLoader.loadRandomActsOfKindness()
    
    func addAlarm(_ alarm: Alarm) {
        alarms.append(alarm)
    }
    
    func removeAlarm(_ alarm: Alarm) {
        if let index = alarms.firstIndex(of: alarm) {
            alarms.remove(at: index)
        }
    }
    
    func updateAlarm(_ alarm: Alarm) {
        if let index = alarms.firstIndex(of: alarm) {
            alarms[index] = alarm
        }
    }
    
    func getAlarm(by id: UUID?) -> Alarm? {
        guard let id = id else { return nil }
        return alarms.first(where: { $0.id == id })
    }
    
    func snoozeAlarm(alarm: Alarm, completion: @escaping (Bool) -> Void) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index].snoozeCount += 1
            completion(alarms[index].snoozeCount > 2)
        }
    }
}
