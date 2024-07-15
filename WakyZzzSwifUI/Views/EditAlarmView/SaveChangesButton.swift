//
//  SaveChangesButton.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

/// A button that saves changes and dismisses the view.
struct SaveChangesButton: View {
    @Environment(\.presentationMode) var presentationMode
    var viewModel: EditAlarmViewModel
    var onDismiss: () -> Void
    
    var body: some View {
        Button("Save Changes") {
            print("Save Changes button pressed.")
            print("Before saving, time: \(viewModel.time)")
            viewModel.saveChanges()
            onDismiss()
            print("View dismissed.")
        }
    }
}

#Preview {
    SaveChangesButton(viewModel: EditAlarmViewModel(alarm: Alarm.example, alarmManager: MockAlarmManager())) {
        print("Preview: View dismissed.")
    }
}
