//
//  AlarmRow.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

struct AlarmRow: View {
    @ObservedObject var viewModel: AlarmRowViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.alarm.time, style: .time)
            Spacer()
            Toggle(isOn: $viewModel.isEnabled) {
                Text(viewModel.isEnabled ? "Enabled" : "Disabled")
            }
            .onChange(of: viewModel.isEnabled) { _, newValue in
                viewModel.toggleEnabled(newValue)
            }
        }
    }
}

//#Preview {
//    AlarmRow(alarm: alarm)
//}
