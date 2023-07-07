//
//  URLSession+Extension.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 08.07.2023.
//

import UIKit

private let httpStatusCodeSuccess = 200..<300

enum RequestError: Error {
    case failedResponse
}

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data,
                          let response = response as? HTTPURLResponse,
                          httpStatusCodeSuccess.contains(response.statusCode) {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: RequestError.failedResponse)
                }
            }

            if Task.isCancelled {
                task.cancel()
            } else {
                task.resume()
            }
        }
    }
}
