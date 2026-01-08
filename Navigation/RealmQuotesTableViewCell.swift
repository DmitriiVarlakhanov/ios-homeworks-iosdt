//
//  RealmQuotesTableViewCell.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 1/7/26.
//

import UIKit

class RealmQuotesTableViewCell: UITableViewCell {

    // MARK: - Properties

    private lazy var labelForQuote: UILabel = {
        let labelForQuote = UILabel()

        labelForQuote.translatesAutoresizingMaskIntoConstraints = false

        labelForQuote.numberOfLines = 6
        labelForQuote.textAlignment = .left
        labelForQuote.textColor = .black
        labelForQuote.font = UIFont.systemFont(ofSize: 17, weight: .medium)

        return labelForQuote
    }()

    private lazy var labelForDate: UILabel = {
        let labelForDate = UILabel()

        labelForDate.translatesAutoresizingMaskIntoConstraints = false

        labelForDate.numberOfLines = 6
        labelForDate.textAlignment = .left
        labelForDate.textColor = .black
        labelForDate.font = UIFont.systemFont(ofSize: 17, weight: .medium)

        return labelForDate
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
        self.contentView.addSubview(labelForQuote)
        self.contentView.addSubview(labelForDate)
    }

    private func setupConstraints() {
        let safeAreaGuide = self.contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.labelForQuote.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 5),
            self.labelForQuote.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 5),
            self.labelForQuote.widthAnchor.constraint(equalToConstant: 250),
            self.labelForQuote.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -5),

            self.labelForDate.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 5),
            self.labelForDate.leadingAnchor.constraint(equalTo: labelForQuote.trailingAnchor, constant: 5),
            self.labelForDate.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -5),
            self.labelForDate.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -5),
        ])
    }

    // MARK: - Public

    func update(textForQuote: String, date: Date) {
        self.labelForQuote.text = textForQuote
        self.labelForDate.text = date.formatted(date: .long, time: .complete)
    }
}
