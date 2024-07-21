//
//  AlarmTimePickerView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

/// A view that provides a time picker for setting the alarm time.
struct AlarmTimePickerView: View {
    /// The binding to the alarm time.
    @Binding var time: Date
    
    var body: some View {
        // DatePicker to select the alarm time, displayed as a wheel.
        DatePicker("Alarm Time", selection: $time, displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle()) // Use the wheel style for the DatePicker.
            .onChange(of: time) { _, newValue in
                // Print the new selected time to the console whenever it changes.
                print("DatePicker changed time to: \(newValue)")
            }
    }
}

#Preview {
    AlarmTimePickerView(time: .constant(Date()))
}
