//
//  AddAlarmButton.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

struct AddAlarmButton: View {
    @Environment(\.presentationMode) var presentationMode
    var viewModel: AddAlarmViewModel

    var body: some View {
        Button("Add Alarm") {
            viewModel.addAlarm()
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    AddAlarmButton(viewModel: AddAlarmViewModel(alarms: .constant([]), isPresented: .constant(false)))
}
