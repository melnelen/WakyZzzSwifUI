//
//  EditAlarmViewModel.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

/// ViewModel for editing an existing alarm.
class EditAlarmViewModel: ObservableObject {
    @Published var alarm: Alarm
    @Published var time: Date
    @Published var repeatDays: [String]
    @Published var isEnabled: Bool
    
    var alarmManager: AlarmManagerProtocol
    
    /// Initializes the ViewModel with an alarm and an optional alarm manager.
    /// - Parameters:
    ///   - alarm: The alarm to be edited.
    ///   - alarmManager: The alarm manager to handle alarm-related tasks, defaults to the shared instance.
    init(alarm: Alarm, alarmManager: AlarmManagerProtocol = AlarmManager.shared) {
        self.alarmManager = alarmManager
        
        // Initialize alarm properties first
        self.alarm = alarm
        self.repeatDays = alarm.repeatDays
        self.isEnabled = alarm.isEnabled
        
        // Handle the time initialization
        if alarm.time <= Date.distantPast {
            var components = DateComponents()
            components.hour = 8
            components.minute = 0
            var defaultTime = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            defaultTime = Calendar.current.nextDate(after: defaultTime, matching: components, matchingPolicy: .nextTime) ?? defaultTime
            self.time = defaultTime
        } else {
            self.time = alarm.time
        }
        
        print("Initialized EditAlarmViewModel with time: \(self.time)")
    }
    
    /// Saves the changes made to the alarm.
    func saveChanges() {
        alarm.time = time
        alarm.repeatDays = repeatDays
        alarm.isEnabled = isEnabled
        alarmManager.updateAlarm(alarm: alarm)
    }
    
    /// Deletes the current alarm.
    func deleteAlarm() {
        alarmManager.removeAlarm(alarm)
    }
}
