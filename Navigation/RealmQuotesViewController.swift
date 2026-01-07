//
//  RealmQuotesViewController.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 1/7/26.
//

import UIKit
import RealmSwift

class RealmQuotesViewController: UIViewController {

    // MARK: - Properties

    var category: String = ""

    var realmModelForQuotesViewControllerArray: [RealmModelForQuotesViewController] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.allowsSelection = false

        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(
            RealmQuotesTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.firstCustom.rawValue
        )

        tableView.dataSource = self

        return tableView
    }()

    private enum CellReuseID: String {
        case firstCustom = "RealmQuotesTableViewCell_ReuseID"
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupRootView()
        self.addSubviews()
        self.setupConstraints()
        self.getRealmModelForQuotesViewControllerArray()
    }

    // MARK: - Private

    private func setupRootView() {
        self.view.backgroundColor = .systemBackground
    }

    private func addSubviews() {
        self.view.addSubview(tableView)
    }

    private func setupConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }

    private func getRealmModelForQuotesViewControllerArray() {
        let realm = try! Realm()

        let objects = realm.objects(RealmModel.self)

        for object in objects {
            if object.categories.contains(self.category) {
                let realmModelForQuotesViewController = RealmModelForQuotesViewController(
                    value: object.value,
                    date: object.date
                )

                self.realmModelForQuotesViewControllerArray.append(realmModelForQuotesViewController)
            }
        }

        self.realmModelForQuotesViewControllerArray.sort { $0.date > $1.date }
    }
}

    // MARK: - Extensions

extension RealmQuotesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.realmModelForQuotesViewControllerArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellReuseID.firstCustom.rawValue,
            for: indexPath
        ) as? RealmQuotesTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }

        cell.update(
            textForQuote: self.realmModelForQuotesViewControllerArray[indexPath.row].value,
            date: self.realmModelForQuotesViewControllerArray[indexPath.row].date
        )

        return cell
    }
}

