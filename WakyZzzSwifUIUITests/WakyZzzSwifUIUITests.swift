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
        
        
        
        // Delete all alarms created during the test
        let alarmsList = app.tables
        
        if alarmsList.cells.count > 0 {
            //            alarmsList.cells.buttons["Delete"].tap()
            //            let deleteButton = alarmsList.buttons["Delete"]
            //            if deleteButton.exists {
            //                deleteButton.tap()
            //            }
        }
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
    
    private func waitForElementToAppear(_ element: XCUIElement) {
        let existsPredicate = NSPredicate(format: "exists == true")
        let interval: TimeInterval = 10
        
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: interval, handler: nil)
    }
}
