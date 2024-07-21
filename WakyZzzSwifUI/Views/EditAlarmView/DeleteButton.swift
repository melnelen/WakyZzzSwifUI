//
//  DeleteButton.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 20/07/2024.
//

import SwiftUI

/// A button to delete the alarm.
struct DeleteButton: View {
    @ObservedObject var viewModel: EditAlarmViewModel
    var onDismiss: () -> Void
    
    var body: some View {
        Button("Delete Alarm") {
            viewModel.deleteAlarm()
            onDismiss()
        }
        .foregroundColor(.red)
    }
}
