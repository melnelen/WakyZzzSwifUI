//
//  AddAlarmView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI

/// A view for adding a new alarm.
struct AddAlarmView: View {
    /// The view model that manages the state and behavior of the add alarm functionality.
    @ObservedObject var viewModel: AddAlarmViewModel
    @Environment(\.presentationMode) var presentationMode

    /// Initializes the view with a binding to the list of alarms and a binding to the presentation state.
    /// - Parameters:
    ///   - alarms: A binding to the array of alarms.
    ///   - isPresented: A binding to the presentation state of the view.
    ///   - alarmManager: The alarm manager to handle alarm-related tasks, default is an instance of `AlarmManager`.
    init(alarms: Binding<[Alarm]>, isPresented: Binding<Bool>, alarmManager: AlarmManagerProtocol = AlarmManager.shared) {
            self.viewModel = AddAlarmViewModel(alarms: alarms, isPresented: isPresented, alarmManager: alarmManager)
        }

    var body: some View {
        NavigationView {
            Form {
                // Picker to select the alarm time
                AlarmTimePickerView(time: $viewModel.time)
                
                // Section to select repeat days
                RepeatDaysSectionView(repeatDays: $viewModel.repeatDays)
                
                // Toggle to enable or disable the alarm
                AlarmToggleView(isEnabled: $viewModel.isEnabled)
                
                // Button to add the new alarm
                AddAlarmButton(viewModel: viewModel)
            }
            .navigationTitle("Add Alarm")
            .navigationBarItems(trailing: CancelButton {
                print("Cancel button pressed.")
                presentationMode.wrappedValue.dismiss()
                print("View should be dismissed.")
            })
        }
    }
}

struct AddAlarmView_Previews: PreviewProvider {
    @State static var alarms: [Alarm] = [Alarm.example]
    static var previews: some View {
        AddAlarmView(alarms: $alarms, isPresented: .constant(true))
    }
}
