//
//  AddAlarmViewModelTests.swift
//  WakyZzzSwifUITests
//
//  Created by Alexandra Ivanova on 09/07/2024.
//

import XCTest
import SwiftUI
@testable import WakyZzzSwifUI

class AddAlarmViewModelTests: XCTestCase {
    var viewModel: AddAlarmViewModel!
    var alarmManager: AlarmManager!
    var alarms: Binding<[Alarm]>!
    var isPresented: Binding<Bool>!
    
    override func setUp() {
        super.setUp()
        alarmManager = AlarmManager()
        alarms = .constant([])
        isPresented = .constant(false)
    }
    
    override func tearDown() {
        viewModel = nil
        alarmManager = nil
        super.tearDown()
    }
    
    func testAddAlarmIncreasesAlarmManagerAlarmsCount() {
        // Given
        viewModel = AddAlarmViewModel(alarms: alarms, isPresented: isPresented, alarmManager: alarmManager)
        let initialAlarmsCount = alarmManager.alarms.count
        viewModel.time = Date().addingTimeInterval(3600)
        viewModel.repeatDays = ["Tuesday", "Thursday"]
        viewModel.isEnabled = false
        
        // When
        viewModel.addAlarm()
        
        // Then
        XCTAssertEqual(alarmManager.alarms.count, initialAlarmsCount + 1)
    }
    
    func testAddAlarmDismissesView() {
        // Given
        viewModel = AddAlarmViewModel(alarms: alarms, isPresented: isPresented, alarmManager: alarmManager)
        viewModel.time = Date().addingTimeInterval(18000)
        viewModel.repeatDays = ["Tuesday"]
        viewModel.isEnabled = true
        
        // When
        viewModel.addAlarm()
        
        // Then
        XCTAssertFalse(isPresented.wrappedValue)
    }
    
    func testCancel() {
        // Given
        isPresented.wrappedValue = true
        viewModel = AddAlarmViewModel(alarms: alarms, isPresented: isPresented, alarmManager: alarmManager)
        
        // When
        viewModel.cancel()
        
        // Then
        XCTAssertFalse(isPresented.wrappedValue)
    }
}
