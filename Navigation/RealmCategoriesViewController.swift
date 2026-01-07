//
//  RealmCategoriesViewController.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 1/6/26.
//

import UIKit
import RealmSwift

class RealmCategoriesViewController: UIViewController {

    // MARK: - Properties

    var arrayOfCategoriesWithoutDublicatesSorted: [String] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.allowsSelection = true

        tableView.register(
            RealmCategoriesTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.firstCustom.rawValue
        )

        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    private enum CellReuseID: String {
        case firstCustom = "RealmCategoriesTableViewCell_ReuseID"
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupRootView()
        self.addSubviews()
        self.setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
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
}

    // MARK: - Extensions

extension RealmCategoriesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()

        let objects = realm.objects(RealmModel.self)

        var arrayOfCategoriesWithDublicates: [String] = []

        var arrayOfCategoriesWithoutDublicatesSorted: [String] = []

        for object in objects {
            for category in object.categories {
                arrayOfCategoriesWithDublicates.append(category)
            }
        }

        arrayOfCategoriesWithoutDublicatesSorted = Array(Set(arrayOfCategoriesWithDublicates)).sorted()

        self.arrayOfCategoriesWithoutDublicatesSorted = arrayOfCategoriesWithoutDublicatesSorted

        return arrayOfCategoriesWithoutDublicatesSorted.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellReuseID.firstCustom.rawValue,
            for: indexPath
        ) as? RealmCategoriesTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }

        cell.update(text: self.arrayOfCategoriesWithoutDublicatesSorted[indexPath.row])

        return cell
    }
}

extension RealmCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realmQuotesViewController = RealmQuotesViewController()

        realmQuotesViewController.category = self.arrayOfCategoriesWithoutDublicatesSorted[indexPath.row]

        self.navigationController?.pushViewController(realmQuotesViewController, animated: true)
    }
}
