//
//  DataServiceError.swift
//  Daytona
//
//  Created by Anton Ostrovskii on 9/3/22.
//

import Foundation

enum DataServiceError: Error {
    case endpointError
    case fetchError(code: Int?)
    case fetchError(error: Error)
    case noData
    case decodingError
}
