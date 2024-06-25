//
//  EditAlarmView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI

struct EditAlarmView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var alarms: [Alarm]
    @State private var alarm: Alarm
    
    @State private var time: Date
    @State private var repeatDays: [String]
    @State private var isEnabled: Bool
    
    init(alarms: Binding<[Alarm]>, alarm: Alarm) {
        self._alarms = alarms
        self._alarm = State(initialValue: alarm)
        self._time = State(initialValue: alarm.time)
        self._repeatDays = State(initialValue: alarm.repeatDays)
        self._isEnabled = State(initialValue: alarm.isEnabled)
    }
    
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
                
                Button("Save Changes") {
                    saveChanges()
                    sortAlarms()
                    AlarmManager.shared.updateAlarm(alarm)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Edit Alarm")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func saveChanges() {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index].time = time
            alarms[index].repeatDays = repeatDays
            alarms[index].isEnabled = isEnabled
            alarms[index].snoozeCount = 0 // Reset snooze count on save
        }
    }
    
    private func sortAlarms() {
        alarms.sort { $0.time < $1.time }
    }
}

struct EditAlarmView_Previews: PreviewProvider {
    @State static var alarms: [Alarm] = [
        Alarm(time: Date())
    ]
    static var previews: some View {
        EditAlarmView(alarms: $alarms, alarm: alarms[0])
    }
}
