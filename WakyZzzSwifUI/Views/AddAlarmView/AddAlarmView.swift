//
//  AddAlarmView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import SwiftUI

struct AddAlarmView: View {
    @ObservedObject var viewModel: AddAlarmViewModel

    init(alarms: Binding<[Alarm]>, isPresented: Binding<Bool>, alarmManager: AlarmManagerProtocol = AlarmManager()) {
        self.viewModel = AddAlarmViewModel(alarms: alarms, isPresented: isPresented, alarmManager: alarmManager)
    }

    var body: some View {
        NavigationView {
            Form {
                AlarmTimePickerView(time: $viewModel.time)
                RepeatDaysSectionView(repeatDays: $viewModel.repeatDays)
                AlarmToggleView(isEnabled: $viewModel.isEnabled)
                AddAlarmButton(viewModel: viewModel)
            }
            .navigationTitle("Add Alarm")
            .navigationBarItems(trailing: CancelButton { viewModel.cancel() })
        }
    }
}

struct AddAlarmView_Previews: PreviewProvider {
    @State static var alarms: [Alarm] = [Alarm.example]
    static var previews: some View {
        AddAlarmView(alarms: $alarms, isPresented: .constant(true))
    }
}
