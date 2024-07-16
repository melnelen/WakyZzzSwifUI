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
    var mockAlarmManager: MockAlarmManager!
    
    override func setUp() {
        super.setUp()
        mockAlarmManager = MockAlarmManager()
    }

    override func tearDown() {
        mockAlarmManager = nil
        super.tearDown()
    }

    func testInitialization() {
        // Given
        let alarm = Alarm(time: Date(), repeatDays: ["Monday"], isEnabled: true)
        
        // When
        let viewModel = EditAlarmViewModel(alarm: alarm, alarmManager: mockAlarmManager)
        
        // Then
        XCTAssertEqual(viewModel.alarm.id, alarm.id)
        XCTAssertEqual(viewModel.repeatDays, alarm.repeatDays)
        XCTAssertEqual(viewModel.isEnabled, alarm.isEnabled)
        XCTAssertEqual(viewModel.time, alarm.time)
    }
    
    func testSaveChanges() {
        // Given
        let initialTime = Date()
        let alarm = Alarm(time: initialTime, repeatDays: ["Monday"], isEnabled: true)
        let viewModel = EditAlarmViewModel(alarm: alarm, alarmManager: mockAlarmManager)
        
        // When
        let newTime = Calendar.current.date(byAdding: .hour, value: 1, to: initialTime) ?? Date()
        viewModel.time = newTime
        viewModel.repeatDays = ["Tuesday"]
        viewModel.isEnabled = false
        viewModel.saveChanges()
        
        // Then
        XCTAssertEqual(viewModel.alarm.time, newTime)
        XCTAssertEqual(viewModel.alarm.repeatDays, ["Tuesday"])
        XCTAssertEqual(viewModel.alarm.isEnabled, false)
        XCTAssertTrue(mockAlarmManager.didUpdateAlarm)
    }

    func testSaveChangesUpdatesAlarmManager() {
        // Given
        let alarm = Alarm(time: Date(), repeatDays: ["Monday"], isEnabled: true)
        let viewModel = EditAlarmViewModel(alarm: alarm, alarmManager: mockAlarmManager)
        
        // When
        viewModel.time = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        viewModel.repeatDays = ["Tuesday"]
        viewModel.isEnabled = false
        viewModel.saveChanges()
        
        // Then
        XCTAssertEqual(mockAlarmManager.updatedAlarm?.time, viewModel.time)
        XCTAssertEqual(mockAlarmManager.updatedAlarm?.repeatDays, viewModel.repeatDays)
        XCTAssertEqual(mockAlarmManager.updatedAlarm?.isEnabled, viewModel.isEnabled)
    }
}
