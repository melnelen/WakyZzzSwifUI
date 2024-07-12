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
    
    private var alarms: Binding<[Alarm]>
    var notificationManager: NotificationManager
    
    init(alarms: Binding<[Alarm]>, alarm: Alarm, notificationManager: NotificationManager) {
        self.alarms = alarms
        self.notificationManager = notificationManager
        
        self.alarm = alarm
        self.repeatDays = alarm.repeatDays
        self.isEnabled = alarm.isEnabled
        self.time = alarm.time
        
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
        
        notificationManager.alarmManager.updateAlarm(alarm: alarm, isEnabled: isEnabled)
    }
}
