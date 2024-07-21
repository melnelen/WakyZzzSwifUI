//
//  RepeatDaysSectionView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

/// A view that allows users to select the days on which the alarm should repeat.
struct RepeatDaysSectionView: View {
    /// The binding to the array of selected repeat days.
    @Binding var repeatDays: [String]
    
    var body: some View {
        // Section to group the repeat days toggles under a header.
        Section(header: Text("Repeat")) {
            // Loop through each day of the week to create a toggle for each day.
            ForEach(["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], id: \.self) { day in
                // Toggle for each day, showing whether the alarm should repeat on that day.
                Toggle(day, isOn: Binding(
                    get: {
                        // Check if the day is in the repeatDays array.
                        self.repeatDays.contains(day)
                    },
                    set: { newValue in
                        // Update the repeatDays array based on the toggle's new value.
                        if newValue {
                            // Add the day to the array if the toggle is turned on.
                            self.repeatDays.append(day)
                        } else {
                            // Remove the day from the array if the toggle is turned off.
                            self.repeatDays.removeAll { $0 == day }
                        }
                    }
                ))
            }
        }
    }
}

#Preview {
    RepeatDaysSectionView(repeatDays: .constant(["Monday", "Wednesday"]))
}
