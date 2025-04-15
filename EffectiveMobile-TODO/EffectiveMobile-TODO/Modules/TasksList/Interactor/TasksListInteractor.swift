//
//  TasksListInteractor.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 14.04.2025.
//

import Foundation

protocol TasksListInteractorProtocol: AnyObject {
    func obtainTasksFromNet(completion: @escaping ((Result<[Task], Error>) -> Void))
    func obtainTasksFromDataBase(completion: @escaping ((Result<[Task], Error>) -> Void))
    func saveTasks(_ tasks: [Task], completion: @escaping ((Result<Bool, Error>) -> Void))
    func updateTaskDoneState(withId id: String, state: Bool, completion: @escaping ((Result<Bool, Error>) -> Void))
    func deleteTask(_ task: Task, completion: @escaping ((Result<Bool, Error>) -> Void))
}

final class TasksListInteracotr: TasksListInteractorProtocol {

    // MARK: - Private Properties

    private var networkManager: NetworkManagerProtocol
    private var databaseManager: DatabaseManagerProtocol

    // MARK: - Init

    init(
        networkManager: NetworkManagerProtocol,
        databaseManager: DatabaseManagerProtocol
    ) {
        self.networkManager = networkManager
        self.databaseManager = databaseManager
    }

    // MARK: - Internal Methods

    func obtainTasksFromNet(completion: @escaping ((Result<[Task], Error>) -> Void)) {
        networkManager.getTasks(completion: completion)
    }

    func obtainTasksFromDataBase(completion: @escaping ((Result<[Task], Error>) -> Void)) {
        return databaseManager.getTasks(completion: completion)
    }

    func saveTasks(_ tasks: [Task], completion: @escaping ((Result<Bool, Error>) -> Void)) {
        return databaseManager.saveTasks(tasks, completion: completion)
    }

    func updateTaskDoneState(withId id: String, state: Bool, completion: @escaping ((Result<Bool, Error>) -> Void)) {
        return databaseManager.updateTaskDoneState(withId: id, state: state, completion: completion)
    }

    func deleteTask(_ task: Task, completion: @escaping ((Result<Bool, Error>) -> Void)) {
        return databaseManager.deleteTask(task, completion: completion)
    }
}
