//
//  NavigationBarButtonsView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

struct NavigationBarButtonsView: View {
    @ObservedObject var viewModel: AlarmsViewModel

    var body: some View {
        HStack {
            Button(action: {
                viewModel.scheduleTestAlarm()
            }) {
                Text("Test Alarm")
            }
            Text("|")
                .foregroundStyle(Color.blue)
            Button(action: {
                viewModel.showingAddAlarmView = true
            }) {
                Image(systemName: "plus")
            }
        }
    }
}

#Preview {
    NavigationBarButtonsView(viewModel: AlarmsViewModel(notificationDelegate: NotificationDelegate()))
}
