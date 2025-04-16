//
//  CoreDataManagerTests.swift
//  EffectiveMobile-TODOTests
//
//  Created by mm pechenbku on 16.04.2025.
//

import XCTest
import CoreData
@testable import EffectiveMobile_TODO

final class CoreDataManagerTests: XCTestCase {

    var sut: CoreDataManager!


    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = makeInMemoryCoreDataManager()
        sut.clearStorage()

    }

    override func tearDownWithError() throws {
        sut.clearStorage()
        sut = nil
        try super.tearDownWithError()
    }

    func testSaveAndFetchTask() {
        let task = makeSampleTask()
        let expectation = self.expectation(description: "Fetching task")

        sut.saveTask(task)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.sut.getTasks { result in
                switch result {
                case .success(let tasks):
                    XCTAssertEqual(tasks.count, 1)
                    XCTAssertEqual(tasks.first?.id, task.id)
                    XCTAssertEqual(tasks.first?.title, task.title)
                    XCTAssertEqual(tasks.first?.description, task.description)
                    XCTAssertEqual(tasks.first?.date, task.date)
                    XCTAssertEqual(tasks.first?.isDone, task.isDone)
                case .failure(let error):
                    XCTFail("Error fetching task: \(error)")
                }
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2)
    }

    func testUpdateTask() {
        let oldTitle = "Old Title"
        let newTitle = "New Title"

        var task = makeSampleTask(title: oldTitle)
        let expectation = self.expectation(description: "Updating task")

        sut.saveTask(task)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            task = Task(id: task.id, title: newTitle, description: task.description, date: task.date, isDone: task.isDone)

            self.sut.updateTask(task) { result in
                switch result {
                case .success(let isUpdated):
                    XCTAssertTrue(isUpdated)
                    self.sut.getTasks { result in
                        guard case let .success(tasks) = result else {
                            XCTFail("Failed to fetch tasks after update")
                            return
                        }
                        XCTAssertEqual(tasks.first?.title, newTitle)
                    }
                case .failure(let error):
                    XCTFail("Update failed with error: \(error)")
                }
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2)
    }

    func testDeleteTask() {
        let task = makeSampleTask()
        let expectation = self.expectation(description: "Deleting task")

        sut.saveTask(task)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.sut.deleteTask(task) { result in
                switch result {
                case .success(let isDeleted):
                    XCTAssertTrue(isDeleted)
                    self.sut.getTasks { result in
                        guard case let .success(tasks) = result else {
                            XCTFail("Failed to fetch tasks after delete")
                            return
                        }
                        XCTAssertEqual(tasks.count, 0)
                    }
                case .failure(let error):
                    XCTFail("Delete failed with error: \(error)")
                }
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2)
    }

    func testUpdateDoneState() {
        let oldState = false
        let newState = true

        let task = makeSampleTask(isDone: oldState)
        let expectation = self.expectation(description: "Updating isDone state")

        sut.saveTask(task)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.sut.updateTaskDoneState(withId: task.id, state: newState) { result in
                switch result {
                case .success(let isUpdated):
                    XCTAssertTrue(isUpdated)
                    self.sut.getTasks { result in
                        guard case let .success(tasks) = result else {
                            XCTFail("Failed to fetch tasks after update")
                            return
                        }
                        XCTAssertEqual(tasks.first?.isDone, newState)
                    }
                case .failure(let error):
                    XCTFail("Update failed with error: \(error)")
                }
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2)
    }

    func testSaveMultipleTasks() {
        let tasks = [
            makeSampleTask(title: "Task 1"),
            makeSampleTask(title: "Task 2")
        ]

        let expectation = self.expectation(description: "Saving multiple tasks")

        sut.saveTasks(tasks) { result in
            switch result {
            case .success(let isSaved):
                XCTAssertTrue(isSaved)
                self.sut.getTasks { result in
                    guard case let .success(loadedTasks) = result else {
                        XCTFail("Failed to fetch tasks after multiple save")
                        return
                    }
                    XCTAssertEqual(loadedTasks.count, tasks.count)
                }
            case .failure(let error):
                XCTFail("Multiple save failed with error: \(error)")
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

private extension CoreDataManagerTests {
    func makeInMemoryCoreDataManager() -> CoreDataManager {
        let container = NSPersistentContainer(name: "EffectiveMobile-DB")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Loading in-memory store failed \(error)")
            }
        }
        return CoreDataManager(container: container)
    }

    func makeSampleTask(title: String = "Test Task", isDone: Bool = false) -> Task {
            Task(
                id: UUID().uuidString,
                title: title,
                description: "Test Description",
                date: Date(),
                isDone: isDone
            )
        }
}
