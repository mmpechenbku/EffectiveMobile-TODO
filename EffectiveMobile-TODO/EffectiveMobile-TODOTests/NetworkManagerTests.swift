//
//  NetworkManagerTests.swift
//  EffectiveMobile-TODOTests
//
//  Created by mm pechenbku on 16.04.2025.
//

import XCTest
@testable import EffectiveMobile_TODO

final class NetworkManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetTasksSuccessufulltyParsesTasks() {
        let sampleTasks = Tasks(
            items: [
                Task(id: "1", title: "Title 1", description: "Description 1", date: Date(), isDone: false),
                Task(id: "2", title: "Title 2", description: "Description 2", date: Date(), isDone: true)
            ]
        )
        let jsonData = try! JSONEncoder().encode(sampleTasks)

        let mockSession = MockURLSession(data: jsonData, error: nil)
        let manager = NetworkManager(session: mockSession)

        let expectation = self.expectation(description: "getTasks success")

        manager.getTasks { result in
            switch result {
            case .success(let tasks):
                XCTAssertEqual(tasks.count, sampleTasks.items.count)
                XCTAssertNotEqual(tasks[0].id, sampleTasks.items[0].id)
                XCTAssertEqual(tasks[0].title, sampleTasks.items[0].title)
                XCTAssertEqual(tasks[0].description, sampleTasks.items[0].description)
                XCTAssertEqual(tasks[0].date, sampleTasks.items[0].date)
                XCTAssertEqual(tasks[0].isDone, sampleTasks.items[0].isDone)

                XCTAssertNotEqual(tasks[1].id, sampleTasks.items[1].id)
                XCTAssertEqual(tasks[1].title, sampleTasks.items[1].title)
                XCTAssertEqual(tasks[1].description, sampleTasks.items[1].description)
                XCTAssertEqual(tasks[1].date, sampleTasks.items[1].date)
                XCTAssertEqual(tasks[1].isDone, sampleTasks.items[1].isDone)
            case .failure(let error):
                XCTFail("Failure with error: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    func test_getTasks_returnsErrorOnFailure() {
        let mockSession = MockURLSession(data: nil, error: NSError(domain: "Test", code: 123, userInfo: nil))
        let manager = NetworkManager(session: mockSession)

        let expectation = self.expectation(description: "getTasks failure")

        manager.getTasks { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func test_getTasks_returnsErrorOnInvalidJSON() {
        let invalidJson = Data("invalid json".utf8)
        let mockSession = MockURLSession(data: invalidJson, error: nil)
        let manager = NetworkManager(session: mockSession)

        let expectation = self.expectation(description: "getTasks invalid json")

        manager.getTasks { result in
            switch result {
            case .success:
                XCTFail("Expected decoding error, got success")
            case .failure(let error):
                XCTAssertTrue(error is DecodingError)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
