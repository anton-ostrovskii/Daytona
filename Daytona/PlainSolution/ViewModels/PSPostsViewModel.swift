//
//  PSPostsViewModel.swift
//  Daytona
//
//  Created by Anton Ostrovskii on 9/3/22.
//

import UIKit

@objc final class PSPostsViewModel: NSObject {
    private var posts: [Post] = []
    private let dataService: PSDataService

    init(dataService: PSDataService) {
        self.dataService = dataService
    }

    func reload(_ completion: @escaping (Result<Void, Error>) -> ()) {
        dataService.fetch(from: "posts") { [weak self] (result: Result<[Post], DataServiceError>) in
            switch result {
                case .success(let posts):
                    self?.posts = posts
                    completion(.success(()))
                case .failure(let error):
                    self?.posts = []
                    completion(.failure(error))
            }
        }
    }
}

extension PSPostsViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard posts.indices.contains(indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: PSPostCell.cellIdentifier, for: indexPath) as? PSPostCell else { return UITableViewCell() }

        cell.update(with: posts[indexPath.row])
        return cell
    }
}
