//
//  AlarmRowViewModel.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

//import SwiftUI
//import Combine
//
//class AlarmRowViewModel: ObservableObject {
//    @Published var alarm: Alarm
//    @Published var isEnabled: Bool
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    init(alarm: Alarm) {
//        self.alarm = alarm
//        self.isEnabled = alarm.isEnabled
//        
//        $isEnabled
//            .dropFirst() // To ignore the initial assignment
//            .sink { [weak self] newValue in
//                self?.toggleEnabled(newValue)
//            }
//            .store(in: &cancellables)
//    }
//    
//    func toggleEnabled(_ isEnabled: Bool) {
//        alarm.isEnabled = isEnabled
//        AlarmManager.shared.updateAlarm(alarm)
//    }
//}

import SwiftUI

class AlarmRowViewModel: ObservableObject {
    @Published var alarm: Alarm
    @Published var isEnabled: Bool
    
    init(alarm: Alarm) {
        self.alarm = alarm
        self.isEnabled = alarm.isEnabled
    }
    
    func toggleEnabled(_ newValue: Bool) {
        alarm.isEnabled = newValue
        AlarmManager.shared.updateAlarm(alarm)
    }
}
