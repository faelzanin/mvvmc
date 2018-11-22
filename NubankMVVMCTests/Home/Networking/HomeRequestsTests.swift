//
//  HomeRequestsTests.swift
//  NubankMVVMCTests
//
//  Created by Rafael Zanin on 22/11/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import XCTest
@testable import NubankMVVMC

class HomeRequestsTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    // Test request get joke with success
    func testRequestGetJokeWithSuccess() {
        let expectation = self.expectation(description: "Request Get joke with success")
        
        API(withEnviroment: .production).homeServices.getRandomJoke(success: { (joke) in
            XCTAssertNotNil(joke)
            expectation.fulfill()
        }) { (error) in
            XCTFail("⚠️ \(error)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Timeout.value, handler: nil)
    }
    
    // Test request get joke with failure
    func testRequestGetJokeWithFailure() {
        let expectation = self.expectation(description: "Request Get joke with failure")
        
        API(withEnviroment: .mock).homeServices.getRandomJoke(success: { (joke) in
            XCTFail()
            expectation.fulfill()
        }) { (error) in
            XCTAssert(true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Timeout.value, handler: nil)
    }
}
