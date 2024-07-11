//
//  SaveChangesButton.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

struct SaveChangesButton: View {
    @Environment(\.presentationMode) var presentationMode
    var viewModel: EditAlarmViewModel
    
    var body: some View {
        Button("Edit Alarm") {
            print("Before saving, time: \(viewModel.time)")
            viewModel.saveChanges()
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    SaveChangesButton(viewModel: EditAlarmViewModel(alarms: .constant([]), alarm: Alarm.example, notificationManager: NotificationManager()))
}
