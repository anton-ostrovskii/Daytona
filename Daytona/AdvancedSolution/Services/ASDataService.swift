//
//  ASDataService.swift
//  Daytona
//
//  Created by Anton Ostrovskii on 9/3/22.
//

import Foundation

struct ASDataService {
    private let urlSession: URLSession
    private let baseURL = "https://jsonplaceholder.typicode.com/"

    init(_ underlyingSession: URLSession = URLSession.shared) {
        self.urlSession = underlyingSession
    }

    func fetch<T>(from endpoint: String) async throws -> T? where T: Decodable {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endpoint) else {
            throw DataServiceError.endpointError
        }

        let result = try await urlSession.data(from: url)

        guard let statusCode = (result.1 as? HTTPURLResponse)?.statusCode, 200...299 ~= statusCode else {
            throw DataServiceError.fetchError(code: (result.1 as? HTTPURLResponse)?.statusCode)
        }

        guard let response = try? JSONDecoder().decode(T.self, from: result.0) else {
            throw DataServiceError.decodingError
        }

        return response
    }
}
