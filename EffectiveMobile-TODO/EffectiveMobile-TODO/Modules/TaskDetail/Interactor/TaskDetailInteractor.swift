//
//  TaskDetailInteractor.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 14.04.2025.
//

protocol TaskDetailInteractorProtocol: AnyObject {
    func saveTask(_ task: Task)
    func updateTask(_ task: Task, completion: @escaping ((Result<Bool, Error>) -> Void))
}

final class TaskDetailInteractor: TaskDetailInteractorProtocol {

    // MARK: - Private Properties

    private var databaseManager: DatabaseManagerProtocol

    // MARK: - Init

    init(databaseManager: DatabaseManagerProtocol) {
        self.databaseManager = databaseManager
    }

    // MARK: - Internal Methods

    func saveTask(_ task: Task) {
        databaseManager.saveTask(task)
    }

    func updateTask(_ task: Task, completion: @escaping ((Result<Bool, Error>) -> Void)) {
        databaseManager.updateTask(task, completion: completion)
    }
}
