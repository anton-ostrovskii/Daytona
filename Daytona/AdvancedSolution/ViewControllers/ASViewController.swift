//
//  ASViewController.swift
//  Daytona
//
//  Created by Anton Ostrovskii on 9/3/22.
//

import UIKit

final class ASViewController: UIViewController {

    private let dataService: ASDataService

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        return refreshControl
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PSPostCell.self, forCellReuseIdentifier: PSPostCell.cellIdentifier)
        tableView.tableFooterView = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        tableView.allowsSelection = false
        return tableView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        return activityIndicator
    }()

    private lazy var tableViewDataSource: UITableViewDiffableDataSource<PostSection, Post> = {
        let tableViewDataSource = UITableViewDiffableDataSource<PostSection, Post>(tableView: tableView) { tableView, indexPath, post in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PSPostCell.cellIdentifier, for: indexPath) as? PSPostCell else { return UITableViewCell() }

            cell.update(with: post)
            return cell
        }
        return tableViewDataSource
    }()

    init(dataService: ASDataService) {
        self.dataService = dataService 
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadPosts()
    }

    private func loadPosts() {
        updateView(isLoading: true)
        Task { [weak self] in
            guard let posts: [Post] = try? await dataService.fetch(from: "posts") else {
                await MainActor.run {
                    self?.updateView(isLoading: false)
                    self?.present(UIAlertController(title: nil, message: String(localized: "postsViewController.error"), preferredStyle: .alert), animated: true)
                }
                return
            }

            await MainActor.run {
                self?.updateView(isLoading: false)
                var snapshot = NSDiffableDataSourceSnapshot<PostSection, Post>()
                snapshot.appendSections([.main])
                snapshot.appendItems(posts, toSection: .main)
                self?.tableViewDataSource.apply(snapshot)
            }
        }
    }
}

private extension ASViewController {

    enum PostSection: Hashable {
        case main
    }
}

private extension ASViewController {

    func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = String(localized: "postsViewController.title")

        view.addSubview(tableView)
        tableView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }

    func updateView(isLoading: Bool) {
        tableView.isUserInteractionEnabled = !isLoading
        activityIndicator.isHidden = !isLoading
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
        }
    }

    @objc func refreshData(_ sender: Any) {
        loadPosts()
    }
}
