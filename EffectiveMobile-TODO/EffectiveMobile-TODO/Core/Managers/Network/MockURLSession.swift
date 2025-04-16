//
//  MockURLSession.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 16.04.2025.
//

import Foundation

final class MockURLSession: URLSessionProtocol {
    let data: Data?
    let error: Error?

    init(data: Data?, error: Error?) {
        self.data = data
        self.error = error
    }

    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        return MockURLSessionDataTask {
            completionHandler(self.data, nil, self.error)
        }
    }

    private final class MockURLSessionDataTask: URLSessionDataTask, @unchecked Sendable {
        private let closure: () -> Void
        init(_ closure: @escaping () -> Void) {
            self.closure = closure
        }
        override func resume() {
            closure()
        }
    }
}

