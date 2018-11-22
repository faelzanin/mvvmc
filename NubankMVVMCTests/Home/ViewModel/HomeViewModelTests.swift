//
//  HomeViewModelTests.swift
//  NubankMVVMCTests
//
//  Created by Rafael Zanin on 22/11/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import XCTest
@testable import NubankMVVMC

class HomeViewModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    // Test viewModel method loadJoke with success.
    func testGetJokeWithSuccess() {
        let expectation = self.expectation(description: "Get Joke With Success")
        let viewModel = HomeViewModel(with: HomeModel(joke: Joke()))
        XCTAssertNotNil(viewModel)
        
        viewModel.homeObservable.didChange = { status in
            switch status {
            case .loading, .empty:
                XCTAssertTrue(true)
            case .load(let data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            case .errored(let error):
                XCTFail("⚠️ \(error)")
                expectation.fulfill()
            }
        }
        
        viewModel.loadJoke(env: .production)
        waitForExpectations(timeout: Timeout.value, handler: nil)
    }
    
    // Test viewModel method loadJoke with failure.
    func testGetJokeWithFailure() {
        let expectation = self.expectation(description: "Get Joke With Failure")
        let viewModel = HomeViewModel(with: HomeModel(joke: Joke()))
        XCTAssertNotNil(viewModel)
        
        viewModel.homeObservable.didChange = { status in
            switch status {
            case .loading, .empty:
                XCTAssertTrue(true)
            case .load( _):
                XCTFail()
                expectation.fulfill()
            case .errored( _):
                XCTAssertTrue(true)
                expectation.fulfill()
            }
        }
        
        viewModel.loadJoke(env: .mock)
        waitForExpectations(timeout: Timeout.value, handler: nil)
    }

}
