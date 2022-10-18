//
//  CDataService.swift
//  Daytona
//
//  Created by Anton Ostrovskii on 9/5/22.
//

import Foundation
import Combine

struct CDataService {

    private let urlSession: URLSession
    private let baseURL = "https://jsonplaceholder.typicode.com/"

    init(_ underlyingSession: URLSession = URLSession.shared) {
        self.urlSession = underlyingSession
    }

    func fetch<T>(from endpoint: String) -> AnyPublisher<T, Error> where T: Decodable {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endpoint) else {
            return Fail(error: DataServiceError.endpointError).eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
