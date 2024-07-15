//
//  EditAlarmView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI

/// A view for editing an existing alarm.
struct EditAlarmView: View {
    @ObservedObject var viewModel: EditAlarmViewModel
    @Environment(\.presentationMode) var presentationMode

    /// Initializes the view with the necessary parameters.
    /// - Parameters:
    ///   - alarms: The binding to the list of alarms.
    ///   - alarm: The alarm to be edited.
    ///   - alarmManager: The alarm manager to handle alarm-related tasks.
    init(alarms: Binding<[Alarm]>, alarm: Alarm, alarmManager: AlarmManagerProtocol = AlarmManager.shared) {
        self.viewModel = EditAlarmViewModel(alarms: alarms, alarm: alarm, alarmManager: alarmManager)
    }
    
    var body: some View {
        NavigationView {
            Form {
                AlarmTimePickerView(time: $viewModel.time)
                RepeatDaysSectionView(repeatDays: $viewModel.repeatDays)
                AlarmToggleView(isEnabled: $viewModel.isEnabled)
                SaveChangesButton(viewModel: viewModel, onDismiss: {
                    presentationMode.wrappedValue.dismiss()
                })
            }
            .navigationTitle("Edit Alarm")
            .navigationBarItems(trailing: CancelButton {
                print("Cancel button pressed.")
                presentationMode.wrappedValue.dismiss()
                print("View should be dismissed.")
            })
        }
        .onAppear {
            print("EditAlarmView initialized with alarm time: \(viewModel.time)")
        }
    }
}

struct EditAlarmView_Previews: PreviewProvider {
    @State static var alarms: [Alarm] = [Alarm.example]
    static var previews: some View {
        EditAlarmView(alarms: $alarms, alarm: Alarm.example, alarmManager: MockAlarmManager())
    }
}
