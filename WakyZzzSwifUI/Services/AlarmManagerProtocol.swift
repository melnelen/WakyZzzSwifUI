//
//  AlarmManagerProtocol.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 09/07/2024.
//

import Foundation

/// Protocol defining the essential functions and properties for managing alarms.
protocol AlarmManagerProtocol {
    /// The list of all alarms managed by the alarm manager.
    var alarms: [Alarm] { get set }
    
    /// A list of random acts of kindness, used for encouraging positive behavior.
    var randomActsOfKindness: [String] { get }

    /// Adds a new alarm to the list of managed alarms.
    /// - Parameter alarm: The alarm to be added.
    func addAlarm(_ alarm: Alarm)
    
    /// Removes an alarm from the list of managed alarms.
    /// - Parameter alarm: The alarm to be removed.
    func removeAlarm(_ alarm: Alarm)
    
    /// Updates an existing alarm.
    /// - Parameter alarm: The alarm with updated properties.
    func updateAlarm(alarm: Alarm)
    
    /// Retrieves an alarm by its unique identifier.
    /// - Parameter id: The UUID of the alarm to retrieve.
    /// - Returns: The alarm if found, or nil if no alarm matches the given UUID.
    func getAlarm(by id: UUID?) -> Alarm?
    
    /// Snoozes an alarm, incrementing its snooze count.
    /// - Parameters:
    ///   - alarm: The alarm to be snoozed.
    ///   - completion: A closure to be called after snoozing, with a Boolean indicating whether a kindness task should be shown.
    func snoozeAlarm(alarm: Alarm, completion: @escaping (Bool) -> Void)
}
