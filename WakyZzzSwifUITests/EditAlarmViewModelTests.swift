//
//  EditAlarmViewModelTests.swift
//  WakyZzzSwifUITests
//
//  Created by Alexandra Ivanova on 10/07/2024.
//

import XCTest
import SwiftUI
@testable import WakyZzzSwifUI

class EditAlarmViewModelTests: XCTestCase {
    // Helper function to create a Binding
    func binding<T>(_ value: T) -> Binding<T> {
        return Binding(get: { value }, set: { _ in })
    }
    
    func testInitialization() {
        // Given
        let alarm = Alarm(time: Date(), repeatDays: ["Monday"], isEnabled: true)
        let alarms = binding([alarm])
        let notificationManager = MockNotificationManager()
        
        // When
        let viewModel = EditAlarmViewModel(alarms: alarms, alarm: alarm, notificationDelegate: notificationManager)
        
        // Then
        XCTAssertEqual(viewModel.alarm.id, alarm.id)
        XCTAssertEqual(viewModel.repeatDays, alarm.repeatDays)
        XCTAssertEqual(viewModel.isEnabled, alarm.isEnabled)
        XCTAssertEqual(viewModel.time, alarm.time)
    }
    
    func testSaveChanges() {
        // Given
        let alarm = Alarm(time: Date(), repeatDays: ["Monday"], isEnabled: true)
        let alarms = binding([alarm])
        let notificationManager = MockNotificationManager()
        let viewModel = EditAlarmViewModel(alarms: alarms, alarm: alarm, notificationDelegate: notificationManager)
        
        // When
        viewModel.time = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        viewModel.repeatDays = ["Tuesday"]
        viewModel.isEnabled = false
        viewModel.saveChanges()
        
        // Then
        XCTAssertEqual(viewModel.alarm.time, viewModel.time)
        XCTAssertEqual(viewModel.alarm.repeatDays, viewModel.repeatDays)
        XCTAssertEqual(viewModel.alarm.isEnabled, viewModel.isEnabled)
    }
}
