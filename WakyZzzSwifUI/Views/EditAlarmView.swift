//
//  EditAlarmView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI

struct EditAlarmView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: EditAlarmViewModel
    
    init(alarms: Binding<[Alarm]>, alarm: Alarm, notificationDelegate: NotificationDelegate) {
        self.viewModel = EditAlarmViewModel(alarms: alarms, alarm: alarm, notificationDelegate: notificationDelegate)
    }
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Alarm Time", selection: $viewModel.time, displayedComponents: .hourAndMinute)
                    .onChange(of: viewModel.time) { _, newValue in
                        print("DatePicker changed time to: \(newValue)")
                    }
                
                Section(header: Text("Repeat")) {
                    ForEach(["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], id: \.self) { day in
                        Toggle(day, isOn: Binding(
                            get: { self.viewModel.repeatDays.contains(day) },
                            set: { newValue in
                                if newValue {
                                    self.viewModel.repeatDays.append(day)
                                } else {
                                    self.viewModel.repeatDays.removeAll { $0 == day }
                                }
                            }
                        ))
                    }
                }
                
                Toggle(isOn: $viewModel.isEnabled) {
                    Text(viewModel.isEnabled ? "Enabled" : "Disabled")
                }
                
                Button("Save Changes") {
                    print("Before saving, time: \(viewModel.time)")
                    viewModel.saveChanges()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Edit Alarm")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct EditAlarmView_Previews: PreviewProvider {
    @State static var alarms: [Alarm] = [
        Alarm(time: Date())
    ]
    static var previews: some View {
        EditAlarmView(alarms: $alarms, alarm: alarms[0], notificationDelegate: NotificationDelegate())
    }
}
