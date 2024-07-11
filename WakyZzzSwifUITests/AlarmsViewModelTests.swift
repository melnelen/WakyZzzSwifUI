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
    var mockAlarmManager: MockAlarmManager!
    var mockNotificationManager: MockNotificationManager!

    override func setUp() {
        super.setUp()
        mockAlarmManager = MockAlarmManager()
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
}
