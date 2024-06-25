//
//  AddAlarmView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI

struct AddAlarmView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var alarms: [Alarm]
    @State private var time: Date = {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }()
    
    @State private var repeatDays: [String] = []
    @State private var isEnabled: Bool = true
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Alarm Time", selection: $time, displayedComponents: .hourAndMinute)
                
                Section(header: Text("Repeat")) {
                    ForEach(["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], id: \.self) { day in
                        Toggle(day, isOn: Binding(
                            get: { self.repeatDays.contains(day) },
                            set: { newValue in
                                if newValue {
                                    self.repeatDays.append(day)
                                } else {
                                    self.repeatDays.removeAll { $0 == day }
                                }
                            }
                        ))
                    }
                }
                
                Toggle(isOn: $isEnabled) {
                    Text("Enabled")
                }
                
                Button("Add Alarm") {
                    let newAlarm = Alarm(time: time, repeatDays: repeatDays, isEnabled: isEnabled, snoozeCount: 0)
                    alarms.append(newAlarm)
                    AlarmManager.shared.addAlarm(newAlarm)
                    sortAlarms()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add Alarm")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func sortAlarms() {
        alarms.sort { $0.time < $1.time }
    }
}

struct AddAlarmView_Previews: PreviewProvider {
    @State static var alarms: [Alarm] = []

    static var previews: some View {
        AddAlarmView(alarms: $alarms)
    }
}
