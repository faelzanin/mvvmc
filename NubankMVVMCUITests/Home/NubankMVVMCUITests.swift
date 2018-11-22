//
//  NubankMVVMCUITests.swift
//  NubankMVVMCUITests
//
//  Created by Rafael Zanin on 23/10/18.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import XCTest

class NubankMVVMCUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Test for initial state of home
    func testStartHome() {
        
        let loadJokeButton = self.app.buttons["Load Joke"]
        _ = loadJokeButton.waitForExistence(timeout: 2.0)
        XCTAssert(loadJokeButton.exists)
        XCTAssert(loadJokeButton.isEnabled)
        
        let jokeImageView = app.images["images--jokeImageView"]
        _ = jokeImageView.waitForExistence(timeout: 2.0)
        XCTAssert(jokeImageView.exists)
        
        let jokeLabelElement = app.staticTexts.element(matching: .any, identifier: "label--jokeLabel")
        _ = jokeLabelElement.waitForExistence(timeout: 2.0)
        XCTAssertFalse(jokeLabelElement.exists)
    }
    
    
    // Test to load a joke
    func testLoadJoke() {
        
        let loadJokeButton = self.app.buttons["Load Joke"]
        _ = loadJokeButton.waitForExistence(timeout: 2.0)
        XCTAssert(loadJokeButton.exists)
        XCTAssert(loadJokeButton.isEnabled)
        loadJokeButton.tap()
        
        _ = self.app.wait(for: .runningBackground, timeout: 5.0)
        
        let jokeImageView = app.images["images--jokeImageView"]
        _ = jokeImageView.waitForExistence(timeout: 2.0)
        XCTAssert(jokeImageView.exists)
       
        let jokeLabelElement = app.staticTexts.element(matching: .any, identifier: "label--jokeLabel")
        _ = jokeLabelElement.waitForExistence(timeout: 2.0)
        XCTAssertGreaterThan(jokeLabelElement.label.count, 0)
    }

    
}
