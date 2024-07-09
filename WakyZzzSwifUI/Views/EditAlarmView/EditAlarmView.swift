//
//  EditAlarmView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI

struct EditAlarmView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: EditAlarmViewModel
    
    init(alarms: Binding<[Alarm]>, alarm: Alarm, notificationDelegate: NotificationManager) {
        self.viewModel = EditAlarmViewModel(alarms: alarms, alarm: alarm, notificationDelegate: notificationDelegate)
    }
    
    var body: some View {
        NavigationView {
            Form {
                AlarmTimePickerView(time: $viewModel.time)
                RepeatDaysSectionView(repeatDays: $viewModel.repeatDays)
                AlarmToggleView(isEnabled: $viewModel.isEnabled)
                SaveChangesButton(viewModel: viewModel)
            }
            .navigationTitle("Edit Alarm")
            .navigationBarItems(trailing: CancelButton {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct EditAlarmView_Previews: PreviewProvider {
    @State static var alarms: [Alarm] = [Alarm.example]
    static var previews: some View {
        EditAlarmView(alarms: $alarms, alarm: Alarm.example, notificationDelegate: NotificationManager())
    }
}
