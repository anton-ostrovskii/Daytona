//
//  PSPostCell.swift
//  Daytona
//
//  Created by Anton Ostrovskii on 9/3/22.
//

import UIKit

final class PSPostCell: UITableViewCell, CellIdentifiable {

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .systemBackground
        titleLabel.font = .boldSystemFont(ofSize: 16.0)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .natural
        titleLabel.textColor = .systemGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private var bodyLabel: UILabel = {
        let bodyLabel = UILabel()
        bodyLabel.backgroundColor = .systemBackground
        bodyLabel.font = .systemFont(ofSize: 13.0)
        bodyLabel.numberOfLines = 0
        bodyLabel.textAlignment = .natural
        bodyLabel.textColor = .systemGray2
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        return bodyLabel
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with post: Post) {
        titleLabel.text = post.title
        bodyLabel.text = post.body
    }
}

private extension PSPostCell {

    func setupView() {
        backgroundColor = .systemBackground

        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layoutMargins.left),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layoutMargins.top),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layoutMargins.right),

            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layoutMargins.left),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: layoutMargins.bottom),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layoutMargins.right),
            bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -layoutMargins.bottom)
        ])
    }
}
