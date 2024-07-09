//
//  AlarmTimePickerView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

struct AlarmTimePickerView: View {
    @Binding var time: Date
    
    var body: some View {
        DatePicker("Alarm Time", selection: $time, displayedComponents: .hourAndMinute)
            .onChange(of: time) { _, newValue in
                print("DatePicker changed time to: \(newValue)")
            }
    }
}

#Preview {
    AlarmTimePickerView(time: .constant(Date()))
}
