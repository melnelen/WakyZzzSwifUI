//
//  AlarmsViewModelTests.swift
//  WakyZzzSwifUITests
//
//  Created by Alexandra Ivanova on 10/07/2024.
//

import XCTest
import SwiftUI
@testable import WakyZzzSwifUI

class AlarmsViewModelTests: XCTestCase {
    var viewModel: AlarmsViewModel!
    var mockAlarmManager: AlarmManagerProtocol!
    var mockNotificationManager: MockNotificationManager!
    
    override func setUp() {
        super.setUp()
        mockAlarmManager = AlarmManager.shared
        // Reset alarms before each test
        mockAlarmManager.alarms = []
        mockNotificationManager = MockNotificationManager()
        viewModel = AlarmsViewModel(notificationManager: mockNotificationManager, alarmManager: mockAlarmManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAlarmManager = nil
        mockNotificationManager = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.alarms.count, 0)
        XCTAssertFalse(viewModel.showingAddAlarmView)
        XCTAssertNil(viewModel.selectedAlarm)
        XCTAssertFalse(viewModel.showingEditAlarmView)
        XCTAssertFalse(viewModel.showingAlarmAlert)
        XCTAssertNil(viewModel.activeAlarmID)
        XCTAssertFalse(viewModel.showRandomActOfKindness)
        XCTAssertEqual(viewModel.randomActTask, "Do something kind!")
    }
    
        func testScheduleTestAlarm() {
            // Given
            let initialCount = viewModel.alarms.count
    
            // When
            viewModel.scheduleTestAlarm()
    
            // Then
            XCTAssertEqual(viewModel.alarms.count, initialCount + 1)
        }
    
//    func testScheduleTestAlarm() {
//        // Given
//        let initialCount = viewModel.alarms.count
//        
//        // When
//        viewModel.scheduleTestAlarm()
//        
//        XCTAssertEqual(viewModel.alarms.count, initialCount + 1)
//        
//        // Then
//        let expectation = XCTestExpectation(description: "Wait for alarm to be triggered")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//            XCTAssertTrue(self.viewModel.showingAlarmAlert)
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 3.0)
//    }
    
    func testTriggerTestAlarmNotification() {
        // Given
        let alarm = Alarm(time: Date(), repeatDays: [], isEnabled: true)
        
        // When
        viewModel.alarmManager.addAlarm(alarm)
        
        // Then
        let expectation = XCTestExpectation(description: "Wait for test alarm to be triggered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.viewModel.triggerTestAlarmNotification(alarm: alarm)
            XCTAssertTrue(self.viewModel.showingAlarmAlert)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testSnoozeAlarm() {
        // Given
        let alarm = Alarm(time: Date(), repeatDays: [], isEnabled: true)
        viewModel.alarmManager.addAlarm(alarm)
        
        // When
        viewModel.snoozeAlarm(alarm: alarm)
        
        // Then
        XCTAssertEqual(viewModel.alarms.first?.snoozeCount, 1)
    }
    
    func testDeleteAlarm() {
        // Given
        let alarm = Alarm(time: Date().addingTimeInterval(3600), repeatDays: [], isEnabled: true)
        mockAlarmManager.addAlarm(alarm)
        viewModel.alarms = mockAlarmManager.alarms
        let initialCount = viewModel.alarms.count
        
        // When
        viewModel.deleteAlarm(at: IndexSet(integer: 0))
        
        // Then
        XCTAssertEqual(mockAlarmManager.alarms.count, initialCount - 1)
        XCTAssertFalse(mockAlarmManager.alarms.contains(alarm))
    }
    
    func testToggleEnabled() {
        // Given
        let alarm = Alarm(time: Date().addingTimeInterval(3600), repeatDays: [], isEnabled: true)
        mockAlarmManager.addAlarm(alarm)
        viewModel.alarms = mockAlarmManager.alarms
        XCTAssertTrue(viewModel.alarms.first!.isEnabled)
        
        // When
        viewModel.toggleEnabled(for: alarm, isEnabled: false)
        viewModel.alarms = mockAlarmManager.alarms
        
        // Then
        XCTAssertFalse(viewModel.alarms.first!.isEnabled)
        
        viewModel.toggleEnabled(for: alarm, isEnabled: true)
        viewModel.alarms = mockAlarmManager.alarms
        
        XCTAssertTrue(viewModel.alarms.first!.isEnabled)
    }
    
    func testAlarmAlert() {
        // Given
        let alarmID = UUID().uuidString
        NotificationCenter.default.post(name: Notification.Name("AlarmTriggered"), object: alarmID)
        
        // Then
        XCTAssertEqual(viewModel.activeAlarmID, alarmID)
        XCTAssertTrue(viewModel.showingAlarmAlert)
    }
}
