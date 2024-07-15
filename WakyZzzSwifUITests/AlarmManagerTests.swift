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
    var alarmManager: AlarmManager!
    
    override func setUp() {
        super.setUp()
        alarmManager = AlarmManager.shared
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
        XCTAssertTrue(alarmManager.alarms.contains(where: { $0.id == alarm.id }))
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
        XCTAssertFalse(alarmManager.alarms.contains(where: { $0.id == alarm.id }))
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
            XCTAssertTrue(showKindness, "Kindness should be shown for the second snooze")
        }
        
        alarmManager.snoozeAlarm(alarm: alarm) { showKindness in
            XCTAssertTrue(showKindness, "Kindness should be shown for the third snooze")
        }
    }
    
    func testSortAlarms() {
        // Given
        let alarm1 = Alarm(time: Date().addingTimeInterval(3600), repeatDays: ["Monday"], isEnabled: true)
        let alarm2 = Alarm(time: Date().addingTimeInterval(7200), repeatDays: ["Tuesday"], isEnabled: true)
        let alarm3 = Alarm(time: Date().addingTimeInterval(1800), repeatDays: ["Wednesday"], isEnabled: true)
        alarmManager.addAlarm(alarm1)
        alarmManager.addAlarm(alarm2)
        alarmManager.addAlarm(alarm3)
        
        // When
        alarmManager.sortAlarms()
        
        // Then
        XCTAssertEqual(alarmManager.alarms, [alarm3, alarm1, alarm2])
    }
    
    func testIsValidDate() {
        // Given
        let validDate = Date().addingTimeInterval(3600)
        let invalidDate = Date.distantPast
        
        // When
        let isValid = alarmManager.isValidDate(validDate)
        let isInvalid = alarmManager.isValidDate(invalidDate)
        
        // Then
        XCTAssertTrue(isValid)
        XCTAssertFalse(isInvalid)
    }
    
    func testSaveAndLoadAlarms() {
        // Given
        let alarm = Alarm(time: Date().addingTimeInterval(3600), repeatDays: [], isEnabled: true)
        alarmManager.addAlarm(alarm)
        
        // When
        alarmManager.saveAlarms()
        alarmManager.loadAlarms()
        
        // Then
        XCTAssertTrue(alarmManager.alarms.contains(where: { $0.id == alarm.id }))
    }
}
