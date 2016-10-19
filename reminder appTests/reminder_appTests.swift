//
//  reminder_appTests.swift
//  reminder appTests
//
//  Created by Brett Karpinos on 10/9/16.
//
//

import XCTest
@testable import reminder_app

class reminder_appTests: XCTestCase {
    
    //MARK: ReminderApp Tests
    
    // Tests to confirm that the Reminder initializer returns when no name or no date is provided.
    func testReminderInitialization() {
        
        //Success Case
        let potentialItem = Reminder(name: "Alpha Release", date: "Oct-20")
        XCTAssertNotNil(potentialItem)
        
        // Failure cases.
        let noName = Reminder(name: "", date:"Oct-19")
        XCTAssertNil(noName, "Empty name is invalid")
        
        
        //THIS SHOULD BE BAD
        let badDate = Reminder(name: "Empty date is invalid", date:"")
        XCTAssertNil(badDate, "Empty dates are invalid")
    }
    
    
}
