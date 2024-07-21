//
//  WakyZzzSwifUIUITests.swift
//  WakyZzzSwifUIUITests
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import XCTest
import SwiftUI
@testable import WakyZzzSwifUI

final class WakyZzzSwifUIUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        let app = XCUIApplication()
        app.launch()
        
        // MARK: Helper Variables
        let testAlarmTime = Calendar.current.date(byAdding: .second, value: 1, to: Date()) ?? Date()
        let formattedTime = formattedTimeString(for: testAlarmTime)
        
        // MARK: Interactive Elements
        let testAlarmButton = app.buttons["Schedule a test alarm"]
        let verticalScroll = app.collectionViews.containing(.other, identifier:"Vertical scroll bar, 2 pages").element
        let deleteButton = app.collectionViews.buttons["Delete Alarm"]
        
        waitForElementToAppear(testAlarmButton)
        
        // Delete the alarm created during the test
        app.collectionViews["Sidebar"].switches["Alarm set for \(formattedTime)"].tap()
        verticalScroll.swipeUp()
        deleteButton.tap()
    }
    
    private func waitForElementToAppear(_ element: XCUIElement) {
        let existsPredicate = NSPredicate(format: "exists == true")
        let interval: TimeInterval = 10
        
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: interval, handler: nil)
    }
    
    private func formattedTimeString(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func testAlarmAndDoKindness() throws {
        let app = XCUIApplication()
        app.launch()
        
        // MARK: Interactive Elements
        let testAlarmButton = app.buttons["Schedule a test alarm"]
        let alert = app.alerts["Alarm"]
        let alertSnoozeButton = alert.scrollViews.otherElements.buttons["Snooze"]
        let completeTaskButton = app.buttons["Complete Task"]
        let kindnessMessage = app.staticTexts["Well done! Keep spreading kindness."]
        
        testAlarmButton.tap()
        
        waitForElementToAppear(alert)
        alertSnoozeButton.tap()
        
        waitForElementToAppear(alert)
        alertSnoozeButton.tap()
        
        waitForElementToAppear(completeTaskButton)
        completeTaskButton.tap()
        
        waitForElementToAppear(kindnessMessage)
        XCTAssertEqual(kindnessMessage.label, "Well done! Keep spreading kindness.")
    }
    
    func testAlarmAndDoKindnessLater() throws {
        let app = XCUIApplication()
        app.launch()
        
        // MARK: Interactive Elements
        let testAlarmButton = app.buttons["Schedule a test alarm"]
        let alert = app.alerts["Alarm"]
        let alertSnoozeButton = alert.scrollViews.otherElements.buttons["Snooze"]
        let doItLaterButton = app.buttons["Promise to Do It Later"]
        let kindnessMessage = app.staticTexts["Well done! Keep spreading kindness."]
        
        testAlarmButton.tap()
        
        waitForElementToAppear(alert)
        alertSnoozeButton.tap()
        
        waitForElementToAppear(alert)
        alertSnoozeButton.tap()
        
        waitForElementToAppear(doItLaterButton)
        doItLaterButton.tap()
        XCTAssertFalse(kindnessMessage.exists)
    }
}
