//
//  KeychainCreatePasswordViewController.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 1/3/26.
//

import UIKit
import KeychainSwift

class KeychainCreatePasswordViewController: UIViewController {

    // MARK: - Properties

    private var passwordBuffer = ""

    private lazy var keychainViewControllerTextField: MyCustomTestField = {
        let keychainViewControllerTextField = MyCustomTestField(insets: UIEdgeInsets(
            top: 0,
            left: 12,
            bottom: 0,
            right: 12
        ))

        keychainViewControllerTextField.translatesAutoresizingMaskIntoConstraints = false

        return keychainViewControllerTextField
    }()

    private lazy var keychainViewControllerButton: UIButton = {
        let keychainViewControllerButton = UIButton()

        keychainViewControllerButton.translatesAutoresizingMaskIntoConstraints = false
        keychainViewControllerButton.setTitle("Create password", for: .normal)
        keychainViewControllerButton.setTitleColor(.white, for: .normal)
        keychainViewControllerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        keychainViewControllerButton.setBackgroundImage(UIImage(named: "PixelVKColor"), for: .normal)
        keychainViewControllerButton.alpha = 1.0

        keychainViewControllerButton.clipsToBounds = true

        keychainViewControllerButton.layer.cornerRadius = 10

        keychainViewControllerButton.addTarget(
            self,
            action: #selector(keychainViewControllerButtonAction),
            for: .touchUpInside
        )

        return keychainViewControllerButton
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupRootView()
        self.addSubviews()
        self.addConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.keychainRelatedUISetup()
    }

    // MARK: - Actions

    @objc private func keychainViewControllerButtonAction() {
        let keychain = KeychainSwift()

        if self.keychainViewControllerButton.titleLabel!.text == "Create password" {
            if self.keychainViewControllerTextField.text?.count ?? 0 < 4 {
                let alertController = UIAlertController(
                    title: "Wrong password format",
                    message: "Create new password with at least 4 symbols",
                    preferredStyle: .alert
                )

                let action = UIAlertAction(
                    title: "Ok",
                    style: .cancel
                )

                alertController.addAction(action)

                self.present(alertController, animated: true)

                return
            } else {
                self.passwordBuffer = self.keychainViewControllerTextField.text!

                self.keychainViewControllerTextField.text = ""

                self.keychainViewControllerButton.setTitle("Confirm password", for: .normal)

                return
            }
        }

        if self.keychainViewControllerButton.titleLabel!.text == "Confirm password" {
            let passwordToConfirm = self.keychainViewControllerTextField.text ?? ""

            if passwordBuffer == passwordToConfirm {
                keychain.set(passwordBuffer, forKey: "password")

                self.dismiss(animated: true)

                return
            } else {
                let alertController = UIAlertController(
                    title: "Invalid password confirmation",
                    message: "Please try again",
                    preferredStyle: .alert
                )

                let action = UIAlertAction(
                    title: "Ok",
                    style: .cancel
                )

                alertController.addAction(action)

                self.present(alertController, animated: true)

                self.keychainViewControllerTextField.text = ""

                self.keychainViewControllerButton.setTitle("Create password", for: .normal)

                return
            }
        }
    }

    // MARK: - Private

    private func setupRootView() {
        self.view.backgroundColor = .white
    }

    private func keychainRelatedUISetup() {
        self.keychainViewControllerButton.setTitle("Create password", for: .normal)

        self.keychainViewControllerTextField.text = ""
    }

    private func addSubviews() {
        self.view.addSubview(keychainViewControllerTextField)
        self.view.addSubview(keychainViewControllerButton)
    }

    private func addConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            keychainViewControllerTextField.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 300),
            keychainViewControllerTextField.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            keychainViewControllerTextField.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            keychainViewControllerTextField.heightAnchor.constraint(equalToConstant: 50),

            keychainViewControllerButton.topAnchor.constraint(equalTo: keychainViewControllerTextField.bottomAnchor, constant: 16),
            keychainViewControllerButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            keychainViewControllerButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            keychainViewControllerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
