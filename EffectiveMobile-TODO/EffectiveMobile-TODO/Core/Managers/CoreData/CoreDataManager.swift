//
//  CoreDataManager.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 14.04.2025.
//

import CoreData

protocol DatabaseManagerProtocol: AnyObject {
    func getTasks(completion: @escaping ((Result<[Task], Error>) -> Void))
    func saveTask(_ task: Task)
    func saveTasks(_ tasks: [Task], completion: @escaping ((Result<Bool, Error>) -> Void))
    func updateTask(_ task: Task, completion: @escaping ((Result<Bool, Error>) -> Void))
    func updateTaskDoneState(withId id: String, state: Bool, completion: @escaping ((Result<Bool, Error>) -> Void))
    func deleteTask(_ task: Task, completion: @escaping ((Result<Bool, Error>) -> Void))

    func clearStorage()
}

final class CoreDataManager {

    // MARK: - Internal Properties

    static let shared = CoreDataManager()
    var container: NSPersistentContainer

    // MARK: - Private Properties

    private var context: NSManagedObjectContext { self.container.viewContext }

    // MARK: - Init

    private init() {
        self.container = Self.makePersistentContainer()
    }

    init(container: NSPersistentContainer) {
        self.container = container
    }
}

// MARK: - DatabaseManagerProtocol

extension CoreDataManager: DatabaseManagerProtocol {
    func getTasks(completion: @escaping ((Result<[Task], Error>) -> Void)) {
        container.performBackgroundTask { backgroundContext in
            let request = TaskObject.fetchRequest()

            do {
                let result = try backgroundContext.fetch(request)

                let returnArray: [Task] = result.compactMap { object in
                    guard
                        let id = object.uid,
                        let title = object.title,
                        let description = object.taskDescription,
                        let date = object.date
                    else { return nil }
                    return Task(id: id, title: title, description: description, date: date, isDone: object.isDone)
                }
                completion(.success(returnArray))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func saveTask(_ task: Task) {
        container.performBackgroundTask { backgroundContext in
            let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: TaskObject.self), into: backgroundContext) as! TaskObject

            object.uid = task.id
            object.title = task.title
            object.taskDescription = task.description
            object.date = task.date
            object.isDone = task.isDone

            try? backgroundContext.save()
        }
    }

    func saveTasks(_ tasks: [Task], completion: @escaping ((Result<Bool, Error>) -> Void)) {
        container.performBackgroundTask { backgroundContext in
            for task in tasks {
                let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: TaskObject.self), into: backgroundContext) as! TaskObject

                object.uid = task.id
                object.title = task.title
                object.taskDescription = task.description
                object.date = task.date
                object.isDone = task.isDone
            }
            
            do {
                try backgroundContext.save()
                completion(.success(true))
            } catch {
                backgroundContext.rollback()
                completion(.failure(error))
            }
        }
    }

    func updateTask(_ task: Task, completion: @escaping ((Result<Bool, Error>) -> Void)) {
        container.performBackgroundTask { backgroundContext in
            let request = TaskObject.fetchRequest()
            request.predicate = NSPredicate(format: "uid == %@", task.id)

            do {
                let tasks = try backgroundContext.fetch(request)

                guard let findedTask = tasks.first(where: { $0.uid == task.id }) else {
                    completion(.success(false))
                    return
                }

                findedTask.title = task.title
                findedTask.taskDescription = task.description
                findedTask.date = task.date
                findedTask.isDone = task.isDone

                do {
                    try backgroundContext.save()
                    completion(.success(true))
                } catch {
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    func updateTaskDoneState(withId id: String, state: Bool, completion: @escaping ((Result<Bool, Error>) -> Void)) {
        container.performBackgroundTask { backgroundContext in
            let request = TaskObject.fetchRequest()
            request.predicate = NSPredicate(format: "uid == %@", id)
            do {
                let tasks = try backgroundContext.fetch(request)

                guard let findedTask = tasks.first(where: { $0.uid == id }) else {
                    completion(.success(false))
                    return
                }

                findedTask.isDone = state

                do {
                    try backgroundContext.save()
                    completion(.success(state))
                } catch {
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    func deleteTask(_ task: Task, completion: @escaping ((Result<Bool, Error>) -> Void)) {

        container.performBackgroundTask { backgroundContext in
            let request = TaskObject.fetchRequest()
            request.predicate = NSPredicate(format: "uid == %@", task.id)

            do {
                let result = try backgroundContext.fetch(request)
                guard let object = result.first else {
                    completion(.success(false))
                    return
                }
                backgroundContext.delete(object)
                do {
                    try backgroundContext.save()
                    completion(.success(true))
                } catch {
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    func clearStorage() {
        let coordinator = self.container.persistentStoreCoordinator
        coordinator.persistentStores.compactMap { $0.url }.forEach {
            try? coordinator.destroyPersistentStore(at: $0, type: .sqlite)
        }
        self.container = Self.makePersistentContainer()
    }
}


// MARK: - Private Methods

private extension CoreDataManager {
    static func makePersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "EffectiveMobile-DB")
        container.loadPersistentStores { _, error in
            if let error = error {
                debugPrint("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }
}
