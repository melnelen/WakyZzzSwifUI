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
        mockAlarmManager.alarms = []  // Reset alarms before each test
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
        let initialCount = viewModel.alarms.count
        
        viewModel.scheduleTestAlarm()
        
        XCTAssertEqual(viewModel.alarms.count, initialCount + 1)
    }

    func testSnoozeAlarm() {
        let alarm = Alarm(time: Date(), repeatDays: [], isEnabled: true)
        viewModel.alarmManager.addAlarm(alarm)
        
        viewModel.snoozeAlarm(alarm: alarm)
        
        XCTAssertEqual(viewModel.alarms.first?.snoozeCount, 1)
    }
    
    func testDeleteAlarm() {
        let alarm = Alarm(time: Date().addingTimeInterval(3600), repeatDays: [], isEnabled: true)
        mockAlarmManager.addAlarm(alarm)
        viewModel.alarms = mockAlarmManager.alarms
        
        let initialCount = viewModel.alarms.count
        
        
        viewModel.deleteAlarm(at: IndexSet(integer: 0))
        
        XCTAssertEqual(mockAlarmManager.alarms.count, initialCount - 1)
        XCTAssertFalse(mockAlarmManager.alarms.contains(alarm))
    }

    func testToggleEnabled() {
        let alarm = Alarm(time: Date().addingTimeInterval(3600), repeatDays: [], isEnabled: true)
        mockAlarmManager.addAlarm(alarm)
        viewModel.alarms = mockAlarmManager.alarms
        XCTAssertTrue(viewModel.alarms.first!.isEnabled)
        
        viewModel.toggleEnabled(for: alarm, isEnabled: false)
        viewModel.alarms = mockAlarmManager.alarms
        
        XCTAssertFalse(viewModel.alarms.first!.isEnabled)
        
        viewModel.toggleEnabled(for: alarm, isEnabled: true)
        viewModel.alarms = mockAlarmManager.alarms
        
        XCTAssertTrue(viewModel.alarms.first!.isEnabled)
    }

    func testAlarmAlert() {
        let alarmID = UUID().uuidString
        NotificationCenter.default.post(name: Notification.Name("AlarmTriggered"), object: alarmID)
        
        XCTAssertEqual(viewModel.activeAlarmID, alarmID)
        XCTAssertTrue(viewModel.showingAlarmAlert)
    }
}
