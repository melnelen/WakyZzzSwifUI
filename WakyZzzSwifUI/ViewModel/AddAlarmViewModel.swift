//
//  AddAlarmViewModel.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

class AddAlarmViewModel: ObservableObject {
    @Published var time: Date
    @Published var repeatDays: [String] = []
    @Published var isEnabled: Bool = true
    
    @Binding var alarms: [Alarm]
    
    private var isPresented: Binding<Bool>
    private var alarmManager: AlarmManagerProtocol
    
    init(alarms: Binding<[Alarm]>, isPresented: Binding<Bool>, alarmManager: AlarmManagerProtocol = AlarmManager()) {
        self._alarms = alarms
        self.isPresented = isPresented
        self.alarmManager = alarmManager

        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        self.time = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime) ?? Date()
    }

    func addAlarm() {
        let newAlarm = Alarm(time: time, repeatDays: repeatDays, isEnabled: isEnabled)
        alarms.append(newAlarm)
        alarmManager.addAlarm(newAlarm)
        isPresented.wrappedValue = false
    }

    func cancel() {
        isPresented.wrappedValue = false
    }
}
