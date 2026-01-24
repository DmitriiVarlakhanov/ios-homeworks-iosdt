//
//  CoreDataViewController.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 1/10/26.
//

import UIKit
import StorageService
import CoreData

class CoreDataViewController: UIViewController {

    // MARK: - Properties

    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = CoreDataPostModel.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "authorLabel", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    private enum CellReuseID: String {
        case firstCustom = "PostTableViewCell_ReuseID"
    }

    // MARK: - Lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)

        self.tabBarItem()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupRootView()
        self.addSubviews()
        self.setupConstraints()
        self.setupTableView()
        self.setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        do {
            try self.fetchedResultsController.performFetch()

            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - Actions

    @objc private func addFilter() {
        let coreDataFilterAuthorViewController = CoreDataFilterAuthorViewController()

        coreDataFilterAuthorViewController.coreDataViewController = self

        self.present(coreDataFilterAuthorViewController, animated: true)
    }

    @objc private func cancelFilter() {

        self.fetchedResultsController.fetchRequest.predicate = nil

        do {
            try self.fetchedResultsController.performFetch()

            self.tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }

        self.tableView.reloadData()
    }

    // MARK: - Private

    private func tabBarItem() {
        self.tabBarItem = UITabBarItem(
            title: "CoreData",
            image: UIImage(systemName: "document"),
            tag: 4
        )
    }

    private func setupRootView() {
        self.view.backgroundColor = .systemBackground
    }

    private func addSubviews() {
        self.view.addSubview(tableView)
    }

    private func setupConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }

    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension

        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()

        tableView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.firstCustom.rawValue
        )

        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass.circle"),
            style: .done,
            target: self,
            action: #selector(addFilter)
        )

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelFilter)
        )
    }
}

    // MARK: - UITableViewDataSource, UITableViewDelegate implementations

extension CoreDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellReuseID.firstCustom.rawValue,
            for: indexPath
        ) as? PostTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }

        cell.contentView.isUserInteractionEnabled = false

        let post = fetchedResultsController.object(at: indexPath)

        cell.updateForCoreData(post)

        return cell
    }
}

extension CoreDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(
            style: .destructive,
            title: "Delete") { action, view, completionHandler in

                let post = self.fetchedResultsController.object(at: indexPath)

                CoreDataManager.shared.deleteFromCoreData(post: post)

                completionHandler(true)
            }

        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [action])

        return swipeActionsConfiguration
    }
}

    // MARK: - NSFetchedResultsControllerDelegate implementation

extension CoreDataViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            return
        case .move:
            return
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            tableView.reloadData()
        @unknown default:
            return
        }
    }
}


