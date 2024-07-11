//
//  EditAlarmViewModel.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import Foundation
import SwiftUI

class EditAlarmViewModel: ObservableObject {
    @Published var alarmManager = AlarmManager()
    @Published var alarm: Alarm
    @Published var time: Date
    @Published var repeatDays: [String]
    @Published var isEnabled: Bool
    
    private var alarms: Binding<[Alarm]>
    var notificationManager: NotificationManager
    
    init(alarms: Binding<[Alarm]>, alarm: Alarm, notificationManager: NotificationManager) {
        self.alarms = alarms
        self.notificationManager = notificationManager
        
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

        if let index = alarms.wrappedValue.firstIndex(where: { $0.id == alarm.id }) {
            print("Saving changes for alarm at index \(index)")
            alarms.wrappedValue[index] = alarm
            print("Updated alarm in array: \(alarms.wrappedValue[index])")
        } else {
            print("Alarm not found! Adding new alarm.")
            alarms.wrappedValue.append(alarm)
            print("Added new alarm: \(alarm)")
        }
        
        alarmManager.updateAlarm(alarm: alarm, isEnabled: isEnabled)
    }
}
