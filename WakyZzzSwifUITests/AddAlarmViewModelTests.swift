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
    var alarmManager: MockAlarmManager!
    var alarms: Binding<[Alarm]>!
    var isPresented: Binding<Bool>!
    
    override func setUp() {
        super.setUp()
        alarmManager = MockAlarmManager()
        alarms = .constant([])
        isPresented = .constant(false)
        viewModel = AddAlarmViewModel(isPresented: isPresented, alarmManager: alarmManager)
    }
    
    override func tearDown() {
        viewModel = nil
        alarmManager = nil
        super.tearDown()
    }
    
    func testDefaultValues() {
        // Given
        let calendar = Calendar.current
        let expectedComponents = DateComponents(hour: 8, minute: 0)
        let expectedTime = calendar.nextDate(after: Date(), matching: expectedComponents, matchingPolicy: .nextTime)!
        
        // Then
        XCTAssertEqual(viewModel.repeatDays, [])
        XCTAssertTrue(viewModel.isEnabled)
        XCTAssertEqual(viewModel.time.timeInMinutes, expectedTime.timeInMinutes)
    }
    
    func testAddAlarmIncreasesAlarmManagerAlarmsCount() {
        // Given
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
        viewModel.time = Date().addingTimeInterval(18000)
        viewModel.repeatDays = ["Tuesday"]
        viewModel.isEnabled = true
        
        // When
        viewModel.addAlarm()
        
        // Then
        XCTAssertFalse(isPresented.wrappedValue)
    }
    
    func testAddAlarmForNextDayAt8AM() {
        // Given
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        let expectedTime = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)!
        
        // When
        viewModel.addAlarm()
        
        // Then
        XCTAssertEqual(alarmManager.alarms.last?.time.timeInMinutes, expectedTime.timeInMinutes)
    }
    
    func testAddAlarmForTodayIfLaterThanCurrentTime() {
        // Given
        let calendar = Calendar.current
        let currentDate = Date()
        let currentTimeComponents = calendar.dateComponents([.hour, .minute], from: currentDate)
        var alarmTimeComponents = DateComponents()
        alarmTimeComponents.hour = currentTimeComponents.hour! + 1
        alarmTimeComponents.minute = currentTimeComponents.minute
        viewModel.time = calendar.date(bySettingHour: alarmTimeComponents.hour!, minute: alarmTimeComponents.minute!, second: 0, of: currentDate)!

        // When
        viewModel.addAlarm()
        
        // Then
        let addedAlarm = alarmManager.alarms.last!
        XCTAssertEqual(addedAlarm.time, viewModel.time)
    }
    
    func testAddAlarmProperties() {
        // Given
        viewModel.time = Date().addingTimeInterval(3600)
        viewModel.repeatDays = ["Monday", "Wednesday"]
        viewModel.isEnabled = true
        
        // When
        viewModel.addAlarm()
        
        // Then
        let addedAlarm = alarmManager.alarms.last!
        XCTAssertEqual(addedAlarm.time, viewModel.time)
        XCTAssertEqual(addedAlarm.repeatDays, ["Monday", "Wednesday"])
        XCTAssertTrue(addedAlarm.isEnabled)
    }
}
