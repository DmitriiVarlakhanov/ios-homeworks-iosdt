//
//  TableViewCellForFileManagerTask.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 12/28/25.
//

import UIKit

class TableViewCellForFileManagerTask: UITableViewCell {

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

    private lazy var customImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill

        imageView.clipsToBounds = true

        return imageView
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
        self.contentView.addSubview(customImageView)
    }

    private func setupConstraints() {
        let safeAreaGuide = self.contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 5),
            self.label.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 5),
            self.label.widthAnchor.constraint(equalToConstant: 250),
            self.label.heightAnchor.constraint(equalToConstant: 70),
            self.label.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -5),

            self.customImageView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            self.customImageView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -20),
            self.customImageView.heightAnchor.constraint(equalToConstant: 60),
            self.customImageView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }

    // MARK: - Public

    func update(modelItem: URL) {
        self.label.text = modelItem.lastPathComponent
        self.customImageView.image = UIImage(contentsOfFile: modelItem.path)
    }
}
