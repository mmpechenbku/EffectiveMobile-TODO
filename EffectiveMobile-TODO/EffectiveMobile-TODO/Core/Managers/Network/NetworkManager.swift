//
//  NetworkManager.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 14.04.2025.
//

protocol NetworkManagerProtocol: AnyObject {
    func getTasks(completion: @escaping ((Result<[Task], Error>) -> Void))
}

final class NetworkManager: NetworkManagerProtocol {

    // MARK: - Internal Properties

    static let shared = NetworkManager()

    // MARK: - Init

    private init() {}

    // MARK: - Internal Methods

    func getTasks(completion: @escaping ((Result<[Task], any Error>) -> Void)) {
        completion(.success(Task.makeMockData()))
    }
}
