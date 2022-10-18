//
//  Post.swift
//  Daytona
//
//  Created by Anton Ostrovskii on 9/3/22.
//

import Foundation

struct Post {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

extension Post: Decodable { }
extension Post: Identifiable { }
extension Post: Sendable { }
extension Post: Hashable { }
