//
//  NetworkManager.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 14.04.2025.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
}

enum APIError: Error {
    case failedToGetData
}

protocol NetworkManagerProtocol: AnyObject {
    func getTasks(completion: @escaping ((Result<[Task], Error>) -> Void))
}

final class NetworkManager: NetworkManagerProtocol {

    // MARK: - Internal Properties

    static let shared = NetworkManager()

    // MARK: - Private Properties

    private let session: URLSessionProtocol
    private let baseAPIURL = "https://dummyjson.com/todos"

    // MARK: - Init

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    // MARK: - Internal Methods

    func getTasks(completion: @escaping ((Result<[Task], any Error>) -> Void)) {
        createRequest(
            with: URL(string: baseAPIURL),
            type: .GET
        ) { request in
            let task = self.session.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(Tasks.self, from: data)
                    completion(.success(result.items))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}

// MARK: - Private Methods

private extension NetworkManager {
    func createRequest(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void
    ) {
        guard let apiUrl = url else { return }

        var request = URLRequest(url: apiUrl)
        request.httpMethod = type.rawValue
        request.timeoutInterval = 30
        completion(request)
    }
}
