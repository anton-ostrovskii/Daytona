//
//  PSPostsViewController.swift
//  Daytona
//
//  Created by Anton Ostrovskii on 9/3/22.
//

import UIKit

/// Plain solution: classic MVVM
final class PSPostsViewController: UIViewController {

    private let viewModel: PSPostsViewModel

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
        tableView.dataSource = viewModel
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

    init(viewModel: PSPostsViewModel) {
        self.viewModel = viewModel 
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
        viewModel.reload { [weak self] result in
            DispatchQueue.main.async {
                self?.updateView(isLoading: false)
                self?.tableView.reloadData()
                if case .failure(let error) = result {
                    self?.present(UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert), animated: true) 
                }
            }
        }
    }
}

private extension PSPostsViewController {

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
