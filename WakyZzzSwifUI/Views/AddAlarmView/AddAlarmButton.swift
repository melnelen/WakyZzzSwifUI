//
//  AddAlarmButton.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

struct AddAlarmButton: View {
    var viewModel: AddAlarmViewModel

    var body: some View {
        Button("Add Alarm") {
            print("Add Alarm button pressed.")
            viewModel.addAlarm()
        }
    }
}

struct AddAlarmButton_Previews: PreviewProvider {
    static var previews: some View {
        AddAlarmButton(viewModel: AddAlarmViewModel(alarms: .constant([]), isPresented: .constant(false), alarmManager: MockAlarmManager()))
    }
}
