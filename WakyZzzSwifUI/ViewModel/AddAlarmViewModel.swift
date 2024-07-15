//
//  AddAlarmViewModel.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

class AddAlarmViewModel: ObservableObject {
    @Published var time: Date
    @Published var repeatDays: [String]
    @Published var isEnabled: Bool
    
    private var alarms: Binding<[Alarm]>
    var isPresented: Binding<Bool>
    var alarmManager: AlarmManagerProtocol
    
    init(alarms: Binding<[Alarm]>, isPresented: Binding<Bool>, alarmManager: AlarmManagerProtocol = AlarmManager.shared) {
        self.alarms = alarms
        self.isPresented = isPresented
        self.alarmManager = alarmManager
        
        // Initialize properties
        self.repeatDays = []
        self.isEnabled = true

        // Set default alarm time to 8 AM the next day
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        if let defaultTime = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime) {
            self.time = defaultTime
        } else {
            self.time = Date()
        }
    }
    
    func addAlarm() {
        let calendar = Calendar.current
        let currentDate = Date()
        let alarmTimeComponents = calendar.dateComponents([.hour, .minute], from: time)
        let currentTimeComponents = calendar.dateComponents([.hour, .minute], from: currentDate)
        
        // If the alarm time is later than the current time today, set the alarm day to today
        if alarmTimeComponents.hour! > currentTimeComponents.hour! ||
           (alarmTimeComponents.hour! == currentTimeComponents.hour! && alarmTimeComponents.minute! > currentTimeComponents.minute!) {
            let todayComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
            self.time = calendar.date(bySettingHour: alarmTimeComponents.hour!, minute: alarmTimeComponents.minute!, second: 0, of: calendar.date(from: todayComponents)!)!
        }
        
        let newAlarm = Alarm(time: time, repeatDays: repeatDays, isEnabled: isEnabled)
        alarmManager.addAlarm(newAlarm)
        alarms.wrappedValue.append(newAlarm)
        isPresented.wrappedValue = false
    }
}
