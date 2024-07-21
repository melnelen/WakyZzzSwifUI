//
//  AddAlarmViewModel.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

/// ViewModel for adding a new alarm.
class AddAlarmViewModel: ObservableObject {
    @Published var time: Date
    @Published var repeatDays: [String]
    @Published var isEnabled: Bool
    
    var isPresented: Binding<Bool>
    var alarmManager: AlarmManagerProtocol
    
    /// Initializes the ViewModel with a binding to the presentation state and an optional alarm manager.
    /// - Parameters:
    ///   - isPresented: Binding to the boolean that controls the presentation of the add alarm view.
    ///   - alarmManager: The alarm manager to handle alarm-related tasks, defaults to the shared instance.
    init(isPresented: Binding<Bool>, alarmManager: AlarmManagerProtocol = AlarmManager.shared) {
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
    
    /// Adds a new alarm with the specified time, repeat days, and enabled state.
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
        isPresented.wrappedValue = false
    }
}
