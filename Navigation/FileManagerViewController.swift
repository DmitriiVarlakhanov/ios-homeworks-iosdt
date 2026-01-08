//
//  FileManagerViewController.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 12/27/25.
//

import UIKit

class FileManagerViewController: UIViewController {

    // MARK: - Properties

    private lazy var addPhotoButton: UIBarButtonItem = {
        let addPhotoButton = UIBarButtonItem(
            image: UIImage(systemName: "photo.badge.plus"),
            style: .done,
            target: self,
            action: #selector(addPhotoButtonTapped)
        )

        return addPhotoButton
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.allowsSelection = false

        tableView.register(
            TableViewCellForFileManagerTask.self,
            forCellReuseIdentifier: CellReuseID.firstCustom.rawValue
        )

        tableView.dataSource = self

        return tableView
    }()

    private enum CellReuseID: String {
        case firstCustom = "TableViewCellForFileManagerTask_ReuseID"
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

        self.setupNavigationBar()
        self.addSubviews()
        self.setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        SettingViewController().sortingOnOff()

        self.tableView.reloadData()
    }

    // MARK: - Actions

    @objc func addPhotoButtonTapped() {
        let imagePickerController = UIImagePickerController()

        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false

        imagePickerController.delegate = self

        self.present(imagePickerController, animated: true)
    }

    // MARK: - Private

    private func tabBarItem() {
        self.tabBarItem = UITabBarItem(
            title: "File Manager",
            image: UIImage(systemName: "filemenu.and.selection") , tag: 2
        )
    }

    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = addPhotoButton
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

extension FileManagerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let url = info[UIImagePickerController.InfoKey.imageURL] as! URL

        FileManagerModel.shared.addItem(url: url)

        self.tableView.reloadData()

        picker.dismiss(animated: true)
    }
}

extension FileManagerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FileManagerModel.shared.itemsForSorting.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellReuseID.firstCustom.rawValue,
            for: indexPath
        ) as? TableViewCellForFileManagerTask else {
            fatalError("could not dequeueReusableCell")
        }

        cell.update(modelItem: FileManagerModel.shared.itemsForSorting[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FileManagerModel.shared.removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
