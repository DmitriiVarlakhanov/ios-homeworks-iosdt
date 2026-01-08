//
//  KeychainViewController.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 1/2/26.
//

import UIKit
import KeychainSwift

class KeychainViewController: UIViewController {

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

        self.addSubviews()
        self.addConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.keychainRelatedUISetup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)

        self.setupTabBarItem()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func keychainViewControllerButtonAction() {
        let keychain = KeychainSwift()

        if keychain.allKeys.isEmpty && self.keychainViewControllerButton.titleLabel!.text == "Create password" {
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

        if keychain.allKeys.isEmpty && self.keychainViewControllerButton.titleLabel!.text == "Confirm password" {
            let passwordToConfirm = self.keychainViewControllerTextField.text ?? ""

            if passwordBuffer == passwordToConfirm {
                keychain.set(passwordBuffer, forKey: "password")

                let tabBarController = UITabBarController()

                let fileManagerNavigationController = UINavigationController(rootViewController: FileManagerViewController())

                let settingNavigationController = UINavigationController(rootViewController: SettingViewController())

                tabBarController.viewControllers = [
                    fileManagerNavigationController,
                    settingNavigationController
                ]

                navigationController?.pushViewController(tabBarController, animated: true)

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

        if !(keychain.allKeys.isEmpty) && self.keychainViewControllerButton.titleLabel!.text == "Enter password" {
            if self.keychainViewControllerTextField.text?.count ?? 0 < 4 {
                let alertController = UIAlertController(
                    title: "Wrong password format",
                    message: "Enter right password",
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

        if !(keychain.allKeys.isEmpty) && self.keychainViewControllerButton.titleLabel!.text == "Confirm password" {
            let passwordToConfirm = self.keychainViewControllerTextField.text ?? ""

            if let keychainPassword = keychain.get("password") {
                if (passwordBuffer == keychainPassword) && (passwordToConfirm == keychainPassword) {

                    let tabBarController = UITabBarController()

                    let fileManagerNavigationController = UINavigationController(rootViewController: FileManagerViewController())

                    let settingNavigationController = UINavigationController(rootViewController: SettingViewController())

                    tabBarController.viewControllers = [
                        fileManagerNavigationController,
                        settingNavigationController
                    ]

                    navigationController?.pushViewController(tabBarController, animated: true)

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

                    self.keychainViewControllerButton.setTitle("Enter password", for: .normal)

                    return
                }
            } else {
                print("Error: No password found in keychain")

                return
            }
        }
    }

    // MARK: - Private

    private func setupTabBarItem() {
        self.tabBarItem = UITabBarItem(
            title: "Keychain password",
            image: UIImage(systemName: "lock.document"),
            tag: 0
        )
    }

    private func keychainRelatedUISetup() {
        let keychain = KeychainSwift()

        if keychain.allKeys.count > 0 {
            self.keychainViewControllerButton.setTitle("Enter password", for: .normal)

            self.keychainViewControllerTextField.text = ""
        } else {
            self.keychainViewControllerButton.setTitle("Create password", for: .normal)

            self.keychainViewControllerTextField.text = ""
        }
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
