//
//  ResidentsTableViewCell.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 12/13/25.
//

import UIKit

class ResidentsTableViewCell: UITableViewCell {

    // MARK: - Properties

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()

        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont.systemFont(ofSize: 20)

        return nameLabel
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func addSubviews() {
        self.contentView.addSubview(nameLabel)
    }

    private func addConstraints() {
        let safeAreaGuide = self.contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor)
        ])
    }

    // MARK: - Public

    func update(residentName: String) {
        self.nameLabel.text = residentName
    }
}
