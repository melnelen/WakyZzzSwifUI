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
    
    @Published var alarms: [Alarm]
    
    private var isPresented: Binding<Bool>
    
    init(alarms: Binding<[Alarm]>, isPresented: Binding<Bool>) {
        self._alarms = Published(initialValue: alarms.wrappedValue)
        self.isPresented = isPresented

        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        self.time = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime) ?? Date()
    }

    func addAlarm() {
        let newAlarm = Alarm(time: time, repeatDays: repeatDays, isEnabled: isEnabled)
        alarms.append(newAlarm)
        AlarmManager.shared.addAlarm(newAlarm)
        isPresented.wrappedValue = false
    }

    func cancel() {
        isPresented.wrappedValue = false
    }
}
