//
//  MockAlarmManager.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 10/07/2024.
//

import Foundation

/// A mock implementation of `AlarmManagerProtocol` for use in testing.
class MockAlarmManager: AlarmManagerProtocol {
    // Singleton instance for shared access
    static let shared = MockAlarmManager()
    
    // List of mock alarms
    var alarms: [Alarm] = []
    // Mock random acts of kindness
    var randomActsOfKindness: [String] = ["Be kind", "Help someone"]
    
    // Flag to indicate if an alarm was updated
    var didUpdateAlarm = false
    // Holds the last updated alarm
    var updatedAlarm: Alarm?
    
    /// Adds an alarm to the mock alarms list.
    /// - Parameter alarm: The alarm to be added.
    func addAlarm(_ alarm: Alarm) {
        alarms.append(alarm)
    }
    
    /// Removes an alarm from the mock alarms list.
    /// - Parameter alarm: The alarm to be removed.
    func removeAlarm(_ alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms.remove(at: index)
        }
    }
    
    /// Updates an alarm in the mock alarms list.
    /// - Parameter alarm: The alarm to be updated.
    func updateAlarm(alarm: Alarm) {
        didUpdateAlarm = true
        updatedAlarm = alarm
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm
        }
    }
    
    /// Retrieves an alarm by its unique identifier.
    /// - Parameter id: The UUID of the alarm.
    /// - Returns: The alarm if found, otherwise nil.
    func getAlarm(by id: UUID?) -> Alarm? {
        guard let id = id else { return nil }
        return alarms.first(where: { $0.id == id })
    }
    
    /// Increments the snooze count of an alarm and triggers a completion handler.
    /// - Parameters:
    ///   - alarm: The alarm to be snoozed.
    ///   - completion: Completion handler that indicates whether to show a random act of kindness.
    func snoozeAlarm(alarm: Alarm, completion: @escaping (Bool) -> Void) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index].snoozeCount += 1
            if alarms[index].snoozeCount >= 2 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    /// Mock implementation for scheduling an alarm.
    /// - Parameter alarm: The alarm to be scheduled.
    func scheduleAlarm(alarm: Alarm) {
        print("Mock: Scheduled alarm with identifier: \(alarm.id)")
    }
    
    /// Mock implementation for disabling an alarm.
    /// - Parameter alarm: The alarm to be disabled.
    func disableAlarm(alarm: Alarm) {
        print("Mock: Disabled alarm with identifier: \(alarm.id)")
    }
    
    /// Mock implementation for enabling an alarm.
    /// - Parameter alarm: The alarm to be enabled.
    func enableAlarm(alarm: Alarm) {
        print("Mock: Enabled alarm with identifier: \(alarm.id)")
    }
}
