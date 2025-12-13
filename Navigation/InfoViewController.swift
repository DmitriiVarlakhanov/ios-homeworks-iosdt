//
//  InfoViewController.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 7/15/25.
//

import UIKit

class InfoViewController: UIViewController {

    // MARK: - Properties

    private lazy var infoVCButton: UIButton = {
        let infoVCButton = UIButton()

        infoVCButton.translatesAutoresizingMaskIntoConstraints = false

        infoVCButton.setTitle("Alert Button", for: .normal)
        infoVCButton.setTitleColor(.black, for: .normal)

        infoVCButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)

        return infoVCButton
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()

        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 3

        return titleLabel
    }()

    private lazy var orbitalPeriodLabel: UILabel = {
        let orbitalPeriodLabel = UILabel()

        orbitalPeriodLabel.translatesAutoresizingMaskIntoConstraints = false

        orbitalPeriodLabel.textAlignment = .center
        orbitalPeriodLabel.numberOfLines = 3

        return orbitalPeriodLabel
    }()

    private lazy var residentsNamesTableView: UITableView = {
        let residentsNamesTableView = UITableView(frame: .zero, style: .plain)

        residentsNamesTableView.translatesAutoresizingMaskIntoConstraints = false

        residentsNamesTableView.allowsSelection = false

        residentsNamesTableView.dataSource = self
        residentsNamesTableView.delegate = self

        residentsNamesTableView.register(
            ResidentsTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.first.rawValue
        )

        return residentsNamesTableView
    }()

    var residents: [ResidentModel] = []

    var residentsURLs: [String] = []

    private enum CellReuseID: String {
        case first = "ResidentsTableViewCell_ReuseID"
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        self.addSubviews()
        self.addConstraints()
        self.urlRequestForTask2()
    }

    // MARK: - Actions

    @objc func showAlert() {
        let alertController = UIAlertController(title: "Alert", message: "This is my first alert", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in print("The user tapped OK") }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in print("The user tapped Cancel") }))

        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Private

    private func addSubviews() {
        self.view.addSubview(infoVCButton)
        self.view.addSubview(titleLabel)
        self.view.addSubview(orbitalPeriodLabel)
        self.view.addSubview(residentsNamesTableView)
    }

    private func addConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 100),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.heightAnchor.constraint(equalToConstant: 100),

            orbitalPeriodLabel.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            orbitalPeriodLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            orbitalPeriodLabel.widthAnchor.constraint(equalToConstant: 150),
            orbitalPeriodLabel.heightAnchor.constraint(equalToConstant: 50),

            infoVCButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            infoVCButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),

            residentsNamesTableView.topAnchor.constraint(equalTo: infoVCButton.bottomAnchor, constant: 30),
            residentsNamesTableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            residentsNamesTableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 30),
            residentsNamesTableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -30)
        ])
    }

    private func urlRequestForTask2() {
        NetworkServiceForTask2.request { title in
            DispatchQueue.main.async {
                self.titleLabel.text = title
            }
        }

        NetworkServiceForTask2.requestUsingDecodable { orbitalPeriod, residentsURLs in
            DispatchQueue.main.async {
                self.orbitalPeriodLabel.text = "Orbital period: \(orbitalPeriod)"
                self.residentsURLs = residentsURLs
                for residentsURL in residentsURLs {
                    NetworkServiceForTask2.requestUsingDecodableForResidents(residentsURL: residentsURL) { residentModel in
                        self.residents.append(residentModel)
                        DispatchQueue.main.async {
                            self.residentsNamesTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension InfoViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource Implementation

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        residents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellReuseID.first.rawValue,
            for: indexPath
        ) as? ResidentsTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }

        cell.update(residentName: residents[indexPath.row].name)

        return cell
    }
}
