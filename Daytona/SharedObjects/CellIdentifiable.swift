//
//  CellIdentifiable.swift
//  Daytona
//
//  Created by Anton Ostrovskii on 9/3/22.
//

import Foundation

protocol CellIdentifiable {
    static var cellIdentifier: String { get }
}

extension CellIdentifiable {
    static var cellIdentifier: String { String(describing: Self.self) }
}
