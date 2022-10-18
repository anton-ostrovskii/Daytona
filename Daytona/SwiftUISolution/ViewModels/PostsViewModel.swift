//
//  PostsViewModel.swift
//  Daytona
//
//  Created by Anton Ostrovskii on 9/5/22.
//

import Foundation
import Combine

final class PostsViewModel: ObservableObject {

    @Published var posts: [Post] = []
    @Published var isRequestFailed = false
    private var cancellable: AnyCancellable?

    private let dataService: CDataService
    init(dataService: CDataService) {
        self.dataService = dataService
    }

    private(set) var error: Error?

    func fetchPosts() {
        cancellable = dataService.fetch(from: "posts")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        self.isRequestFailed = true
                        self.error = error
                    case .finished:
                        self.isRequestFailed = false
                }
            }, receiveValue: { (posts: [Post]) in
                self.posts = posts
            })
    }
}
