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
            viewModel.addAlarm()
        }
    }
}

#Preview {
    AddAlarmButton(viewModel: AddAlarmViewModel(alarms: .constant([]), isPresented: .constant(false)))
}
