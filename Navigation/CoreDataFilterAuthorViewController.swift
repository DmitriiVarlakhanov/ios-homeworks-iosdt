//
//  CoreDataFilterAuthorViewController.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 1/14/26.
//

import UIKit

class CoreDataFilterAuthorViewController: UIViewController {

    // MARK: - Properties

    weak var coreDataViewController: CoreDataViewController?

    private lazy var coreDataFilterAuthorViewControllerTextField: MyCustomTestField = {
        let coreDataFilterAuthorViewControllerTextField = MyCustomTestField(insets: UIEdgeInsets(
            top: 0,
            left: 12,
            bottom: 0,
            right: 12
        ))

        coreDataFilterAuthorViewControllerTextField.translatesAutoresizingMaskIntoConstraints = false

        return coreDataFilterAuthorViewControllerTextField
    }()

    private lazy var coreDataFilterAuthorViewControllerButton: UIButton = {
        let coreDataFilterAuthorViewControllerButton = UIButton()

        coreDataFilterAuthorViewControllerButton.translatesAutoresizingMaskIntoConstraints = false
        coreDataFilterAuthorViewControllerButton.setTitle("Apply", for: .normal)
        coreDataFilterAuthorViewControllerButton.setTitleColor(.white, for: .normal)
        coreDataFilterAuthorViewControllerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        coreDataFilterAuthorViewControllerButton.setBackgroundImage(UIImage(named: "PixelVKColor"), for: .normal)
        coreDataFilterAuthorViewControllerButton.alpha = 1.0

        coreDataFilterAuthorViewControllerButton.clipsToBounds = true

        coreDataFilterAuthorViewControllerButton.layer.cornerRadius = 10

        coreDataFilterAuthorViewControllerButton.addTarget(
            self,
            action: #selector(coreDataFilterAuthorViewControllerButtonAction),
            for: .touchUpInside
        )

        return coreDataFilterAuthorViewControllerButton
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupRootView()
        self.addSubviews()
        self.addConstraints()
    }

    // MARK: - Actions

    @objc private func coreDataFilterAuthorViewControllerButtonAction() {
        guard let text = self.coreDataFilterAuthorViewControllerTextField.text, !text.isEmpty else {
            return
        }

        self.coreDataViewController?.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "authorLabel==%@", text)

        do {
            try coreDataViewController?.fetchedResultsController.performFetch()

            coreDataViewController?.tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }

        self.dismiss(animated: true)
    }

    // MARK: - Private

    private func setupRootView() {
        self.view.backgroundColor = .systemBackground
    }

    private func addSubviews() {
        self.view.addSubview(coreDataFilterAuthorViewControllerTextField)
        self.view.addSubview(coreDataFilterAuthorViewControllerButton)
    }

    private func addConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            coreDataFilterAuthorViewControllerTextField.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 300),
            coreDataFilterAuthorViewControllerTextField.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            coreDataFilterAuthorViewControllerTextField.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            coreDataFilterAuthorViewControllerTextField.heightAnchor.constraint(equalToConstant: 50),

            coreDataFilterAuthorViewControllerButton.topAnchor.constraint(equalTo: coreDataFilterAuthorViewControllerTextField.bottomAnchor, constant: 16),
            coreDataFilterAuthorViewControllerButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            coreDataFilterAuthorViewControllerButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            coreDataFilterAuthorViewControllerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
