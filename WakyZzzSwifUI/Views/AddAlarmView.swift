//
//  AddAlarmView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI

struct AddAlarmView: View {
    @ObservedObject var viewModel: AddAlarmViewModel

    init(alarms: Binding<[Alarm]>, isPresented: Binding<Bool>) {
        self.viewModel = AddAlarmViewModel(alarms: alarms, isPresented: isPresented)
    }

    var body: some View {
        NavigationView {
            Form {
                DatePicker("Alarm Time", selection: $viewModel.time, displayedComponents: .hourAndMinute)

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

                Button("Add Alarm") {
                    viewModel.addAlarm()
                }
            }
            .navigationTitle("Add Alarm")
            .navigationBarItems(trailing: Button("Cancel") {
                viewModel.cancel()
            })
        }
    }
}

struct AddAlarmView_Previews: PreviewProvider {
    @State static var alarms: [Alarm] = []
    @State static var isPresented = true

    static var previews: some View {
        AddAlarmView(alarms: $alarms, isPresented: $isPresented)
    }
}
