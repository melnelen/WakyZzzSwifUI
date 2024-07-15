//
//  AlarmManagerTests.swift
//  WakyZzzSwifUITests
//
//  Created by Alexandra Ivanova on 09/07/2024.
//

import XCTest
import UserNotifications
@testable import WakyZzzSwifUI

class AlarmManagerTests: XCTestCase {
    var alarmManager: AlarmManagerProtocol!
    
    override func setUp() {
        super.setUp()
        alarmManager = MockAlarmManager.shared
        alarmManager.alarms = []  // Reset alarms before each test
    }
    
    override func tearDown() {
        alarmManager = nil
        super.tearDown()
    }
    
    func testAddAlarm() {
        // Given
        let initialAlarmsCount = alarmManager.alarms.count
        let alarm = Alarm(time: Date().addingTimeInterval(3600), repeatDays: ["Monday", "Wednesday"], isEnabled: true)
        
        // When
        alarmManager.addAlarm(alarm)
        
        // Then
        XCTAssertEqual(alarmManager.alarms.count, initialAlarmsCount + 1)
        XCTAssertTrue(alarmManager.alarms.contains(alarm))
    }
    
    func testUpdateAlarm() {
        // Given
        let alarm = Alarm(time: Date().addingTimeInterval(3600), repeatDays: ["Monday", "Wednesday"], isEnabled: true)
        alarmManager.addAlarm(alarm)
        let updatedTime = Date().addingTimeInterval(7200)
        var updatedAlarm = alarm
        updatedAlarm.time = updatedTime
        
        // When
        alarmManager.updateAlarm(alarm: updatedAlarm, isEnabled: updatedAlarm.isEnabled)
        
        // Then
        XCTAssertEqual(alarmManager.alarms.first?.time, updatedTime)
    }
    
    func testRemoveAlarm() {
        // Given
        let alarm = Alarm(time: Date().addingTimeInterval(3600), repeatDays: ["Monday", "Wednesday"], isEnabled: true)
        alarmManager.addAlarm(alarm)
        let initialAlarmsCount = alarmManager.alarms.count
        
        // When
        alarmManager.removeAlarm(alarm)
        
        // Then
        XCTAssertEqual(alarmManager.alarms.count, initialAlarmsCount - 1)
        XCTAssertFalse(alarmManager.alarms.contains(alarm))
    }
    
    func testGetAlarmById() {
        // Given
        let alarm = Alarm(time: Date().addingTimeInterval(3600), repeatDays: ["Monday", "Wednesday"], isEnabled: true)
        alarmManager.addAlarm(alarm)
        
        // When
        let fetchedAlarm = alarmManager.getAlarm(by: alarm.id)
        
        // Then
        XCTAssertNotNil(fetchedAlarm)
        XCTAssertEqual(fetchedAlarm?.id, alarm.id)
    }
    
    func testSnoozeAlarm() {
        // Given
        let alarm = Alarm(time: Date().addingTimeInterval(3600), repeatDays: ["Monday", "Wednesday"], isEnabled: true)
        alarmManager.addAlarm(alarm)
        
        let expectation = self.expectation(description: "Snooze Alarm")
        
        // When
        alarmManager.snoozeAlarm(alarm: alarm) { showKindness in
            // Then
            XCTAssertFalse(showKindness, "Kindness should not be shown for the first snooze")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
        
        alarmManager.snoozeAlarm(alarm: alarm) { showKindness in
            XCTAssertFalse(showKindness, "Kindness should not be shown for the second snooze")
        }
        
        alarmManager.snoozeAlarm(alarm: alarm) { showKindness in
            XCTAssertTrue(showKindness, "Kindness should be shown for the third snooze")
        }
    }
}
