//
//  RepeatDaysSectionView.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

struct RepeatDaysSectionView: View {
    @Binding var repeatDays: [String]
    
    var body: some View {
        Section(header: Text("Repeat")) {
            ForEach(["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], id: \.self) { day in
                Toggle(day, isOn: Binding(
                    get: { self.repeatDays.contains(day) },
                    set: { newValue in
                        if newValue {
                            self.repeatDays.append(day)
                        } else {
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
