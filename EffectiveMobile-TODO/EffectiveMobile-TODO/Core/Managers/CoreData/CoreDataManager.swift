//
//  CoreDataManager.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 14.04.2025.
//

protocol DatabaseManagerProtocol: AnyObject {
    func getTasks() -> [Task]
}

final class CoreDataManager {

    // MARK: - Internal Properties

    static let shared = CoreDataManager()

    // MARK: - Init

    private init() {}
}

// MARK: - DatabaseManagerProtocol

extension CoreDataManager: DatabaseManagerProtocol {
    func getTasks() -> [Task] {
        return Task.makeMockData()
    }
}
