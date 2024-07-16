//
//  EditAlarmViewModel.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

class EditAlarmViewModel: ObservableObject {
    @Published var alarm: Alarm
    @Published var time: Date
    @Published var repeatDays: [String]
    @Published var isEnabled: Bool
    
    var alarmManager: AlarmManagerProtocol
    
    init(alarm: Alarm, alarmManager: AlarmManagerProtocol = AlarmManager.shared) {
        self.alarmManager = alarmManager
        
        // Initialize alarm properties first
        self.alarm = alarm
        self.repeatDays = alarm.repeatDays
        self.isEnabled = alarm.isEnabled

        // Then, handle the time initialization
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
    
    func saveChanges() {
        alarm.time = time
        alarm.repeatDays = repeatDays
        alarm.isEnabled = isEnabled
        alarmManager.updateAlarm(alarm: alarm)
    }
}
