//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 7/13/25.
//

import UIKit
import StorageService

class ProfileViewController: UIViewController {

    // MARK: - Properties

    private lazy var profileTableView: UITableView = {
        let profileTableView = UITableView(frame: .zero, style: .plain)

        profileTableView.translatesAutoresizingMaskIntoConstraints = false

        return profileTableView
    }()

    private enum CellReuseID: String {
        case firstCustom = "PostTableViewCell_ReuseID"
        case secondCustom = "PhotosTableViewCell_ReuseID"
    }

    fileprivate let data = PostModel.make()

    var user: User?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

#if DEBUG
        self.view.backgroundColor = .red
#else
        self.view.backgroundColor = .blue
#endif

        self.view.addSubview(profileTableView)

        setupConstraints()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.isHidden = false

        profileTableView.indexPathsForSelectedRows?.forEach { profileTableView.deselectRow(at: $0, animated: false) }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    // MARK: - Private

    private func setupConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            profileTableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            profileTableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 0),
            profileTableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: 0),
            profileTableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }

    private func setupTableView() {

#if DEBUG
        profileTableView.backgroundColor = .red
#else
        profileTableView.backgroundColor = .blue
#endif

        profileTableView.rowHeight = UITableView.automaticDimension

        profileTableView.tableHeaderView = UIView()
        profileTableView.tableFooterView = UIView()

        profileTableView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.firstCustom.rawValue
        )

        profileTableView.register(
            PhotosTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.secondCustom.rawValue
        )

        profileTableView.dataSource = self
        profileTableView.delegate = self
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.firstCustom.rawValue,
                for: indexPath
            ) as? PostTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }

            cell.update(data[indexPath.row])

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.secondCustom.rawValue,
                for: indexPath
            ) as? PhotosTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }

            return cell
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            data.count
        } else {
            1
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let profileHeaderView = ProfileHeaderView()

            profileHeaderView.update(user: self.user)

            return profileHeaderView
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 230
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let photosViewController = PhotosViewController()

            self.navigationController?.pushViewController(photosViewController, animated: true)
        }
    }
}
