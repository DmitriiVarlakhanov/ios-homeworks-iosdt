//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 8/17/25.
//

import UIKit
import StorageService
import iOSIntPackage

class PostTableViewCell: UITableViewCell {

    // MARK: - Properties

    private lazy var authorLabel: UILabel = {
        let authorLabel = UILabel()

        authorLabel.translatesAutoresizingMaskIntoConstraints = false

        authorLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        authorLabel.textColor = .black
        authorLabel.numberOfLines = 2

        return authorLabel
    }()

    private lazy var imageImageView: UIImageView = {
        let imageImageView = UIImageView()

        imageImageView.translatesAutoresizingMaskIntoConstraints = false

        imageImageView.backgroundColor = .black
        imageImageView.contentMode = .scaleAspectFit

        return imageImageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .systemGray
        descriptionLabel.numberOfLines = 0

        return descriptionLabel
    }()

    private lazy var likesLabel: UILabel = {
        let likesLabel = UILabel()

        likesLabel.translatesAutoresizingMaskIntoConstraints = false

        likesLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        likesLabel.textColor = .black

        return likesLabel
    }()

    private lazy var viewsLabel: UILabel = {
        let viewsLabel = UILabel()

        viewsLabel.translatesAutoresizingMaskIntoConstraints = false

        viewsLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        viewsLabel.textColor = .black

        return viewsLabel
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupTableViewCell()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func doubleTapAction() {
        let imageData = self.imageImageView.image?.pngData() ?? Data()

        CoreDataManager.shared.addToCoreData(
            authorLabel: self.authorLabel.text ?? "",
            imageData: imageData,
            descriptionLabel: self.descriptionLabel.text ?? "",
            likesLabel: self.likesLabel.text ?? "",
            viewsLabel: self.viewsLabel.text ?? ""
        )
    }

    // MARK: - Private

    private func setupTableViewCell() {
        self.selectionStyle = .none

        self.contentView.isUserInteractionEnabled = true

        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(doubleTapAction)
        )

        gestureRecognizer.numberOfTapsRequired = 2

        self.contentView.addGestureRecognizer(gestureRecognizer)
    }

    private func addSubviews() {
        self.contentView.addSubview(authorLabel)
        self.contentView.addSubview(imageImageView)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(likesLabel)
        self.contentView.addSubview(viewsLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),

            imageImageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 12),
            imageImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            imageImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: imageImageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),

            likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            likesLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            likesLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),

            viewsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            viewsLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            viewsLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)

        ])
    }

    // MARK: - Public

    func update(_ model: PostModel) {
        authorLabel.text = model.author

        ImageProcessor().processImage(
            sourceImage: UIImage(named: model.image)!,
            filter: .noir,
            completion: { image in
                self.imageImageView.image = image
            }
        )

        descriptionLabel.text = model.description
        likesLabel.text = "Likes: \(model.likes)"
        viewsLabel.text = "Views: \(model.views)"
    }

    func updateForCoreData(_ model: CoreDataPostModel) {
        authorLabel.text = model.authorLabel

        imageImageView.image = UIImage(data: model.imageData ?? Data())

        descriptionLabel.text = model.descriptionLabel
        likesLabel.text = "\(model.likesLabel ?? "")"
        viewsLabel.text = "\(model.viewsLabel ?? "")"
    }
}
