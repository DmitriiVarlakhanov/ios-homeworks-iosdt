//
//  RealmCategoriesTableViewCell.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 1/6/26.
//

import UIKit

class RealmCategoriesTableViewCell: UITableViewCell {

    // MARK: - Properties

    private lazy var label: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        label.numberOfLines = 3
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)

        return label
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.addSubviews()
        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func addSubviews() {
        self.contentView.addSubview(label)
    }

    private func setupConstraints() {
        let safeAreaGuide = self.contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 5),
            self.label.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 5),
            self.label.widthAnchor.constraint(equalToConstant: 250),
            self.label.heightAnchor.constraint(equalToConstant: 50),
            self.label.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -5),
        ])
    }

    // MARK: - Public

    func update(text: String) {
        self.label.text = text
    }
}

