//
//  TasksListInteractor.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 14.04.2025.
//

protocol TasksListInteractorProtocol: AnyObject {
    func obtainTasksFromNet(completion: @escaping ((Result<[Task], Error>) -> Void))
    func obtainTasksFromDataBase() -> [Task]
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

    func obtainTasksFromNet(completion: @escaping ((Result<[Task], any Error>) -> Void)) {
        networkManager.getTasks(completion: completion)
    }

    func obtainTasksFromDataBase() -> [Task] {
        return databaseManager.getTasks()
    }
}
