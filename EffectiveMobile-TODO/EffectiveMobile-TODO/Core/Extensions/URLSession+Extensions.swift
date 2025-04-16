//
//  URLSession+Extensions.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 16.04.2025.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
