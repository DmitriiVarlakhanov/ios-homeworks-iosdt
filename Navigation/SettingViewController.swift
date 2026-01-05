//
//  SettingViewController.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 1/3/26.
//

import UIKit

class SettingViewController: UIViewController {

    // MARK: - Properties

    private lazy var switchObjectOnOff: UISwitch = {
        let switchObjectOnOff = UISwitch()

        switchObjectOnOff.translatesAutoresizingMaskIntoConstraints = false

        switchObjectOnOff.isOn = UserDefaults.standard.bool(forKey: "sorting")

        switchObjectOnOff.isOn = {
            if let object = UserDefaults.standard.object(forKey: "sorting") {
                return UserDefaults.standard.bool(forKey: "sorting")
            } else {
                return true
            }
        }()

        switchObjectOnOff.addTarget(self, action: #selector(sortingOnOff), for: .valueChanged)

        return switchObjectOnOff
    }()

    private lazy var switchObjectForMode: UISwitch = {
        let switchObjectForMode = UISwitch()

        switchObjectForMode.translatesAutoresizingMaskIntoConstraints = false

        switchObjectForMode.isOn = UserDefaults.standard.bool(forKey: "mode")

        switchObjectForMode.addTarget(self, action: #selector(alphabetOrReversedAlphabetSorting), for: .valueChanged)

        return switchObjectForMode
    }()

    private lazy var labelForOnOff: UILabel = {
        let labelForOnOff = UILabel()

        labelForOnOff.translatesAutoresizingMaskIntoConstraints = false

        labelForOnOff.numberOfLines = 3
        labelForOnOff.textAlignment = .left
        labelForOnOff.textColor = .black
        labelForOnOff.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        labelForOnOff.text = "Sorting"

        return labelForOnOff
    }()

    private lazy var labelForMode: UILabel = {
        let labelForMode = UILabel()

        labelForMode.translatesAutoresizingMaskIntoConstraints = false

        labelForMode.numberOfLines = 3
        labelForMode.textAlignment = .left
        labelForMode.textColor = .black
        labelForMode.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        labelForMode.text = {
            if UserDefaults.standard.bool(forKey: "mode") {
               return "Reversed alphabet sorting"
            } else {
                return "Alphabet sorting"
            }
        }()

        return labelForMode
    }()

    private lazy var changePasswordButton: UIButton = {
        let changePasswordButton = UIButton()

        changePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        changePasswordButton.setTitle("Change password", for: .normal)
        changePasswordButton.setTitleColor(.white, for: .normal)
        changePasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        changePasswordButton.setBackgroundImage(UIImage(named: "PixelVKColor"), for: .normal)
        changePasswordButton.alpha = 1.0

        changePasswordButton.clipsToBounds = true

        changePasswordButton.layer.cornerRadius = 10

        changePasswordButton.addTarget(
            self,
            action: #selector(changePasswordButtonAction),
            for: .touchUpInside
        )

        return changePasswordButton
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubviews()
        self.setupConstraints()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)

        self.setupTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func changePasswordButtonAction() {
        let keychainCreatePasswordViewController = KeychainCreatePasswordViewController()

        keychainCreatePasswordViewController.modalPresentationStyle = .pageSheet
        keychainCreatePasswordViewController.modalTransitionStyle = .coverVertical

        self.present(keychainCreatePasswordViewController, animated: true)
    }

    @objc func sortingOnOff() {
        if self.switchObjectOnOff.isOn {
            UserDefaults.standard.set(switchObjectOnOff.isOn, forKey: "sorting")

            if switchObjectForMode.isOn {
                let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

                let items = try! FileManager.default.contentsOfDirectory(
                    at: path,
                    includingPropertiesForKeys: nil,
                    options: .skipsHiddenFiles
                )

                FileManagerModel.shared.itemsForSorting = items.sorted { $0.lastPathComponent > $1.lastPathComponent }
            } else {
                let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

                let items = try! FileManager.default.contentsOfDirectory(
                    at: path,
                    includingPropertiesForKeys: nil,
                    options: .skipsHiddenFiles
                )

                FileManagerModel.shared.itemsForSorting = items.sorted { $0.lastPathComponent < $1.lastPathComponent }
            }
        } else {
            UserDefaults.standard.set(switchObjectOnOff.isOn, forKey: "sorting")

            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

            FileManagerModel.shared.itemsForSorting = try! FileManager.default.contentsOfDirectory(
                at: path,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
        }
    }

    @objc private func alphabetOrReversedAlphabetSorting() {
        if self.switchObjectForMode.isOn {
            switchObjectForMode.isOn = true

            self.labelForMode.text = "Reversed alphabet sorting"

            UserDefaults.standard.set(switchObjectForMode.isOn, forKey: "mode")
        } else {
            switchObjectForMode.isOn = false

            labelForMode.text = "Alphabet sorting"

            UserDefaults.standard.set(switchObjectForMode.isOn, forKey: "mode")
        }
    }

    // MARK: - Private

    private func setupTabBarItem() {
        self.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            tag: 0
        )
    }

    private func addSubviews() {
        self.view.addSubview(self.switchObjectOnOff)
        self.view.addSubview(self.switchObjectForMode)
        self.view.addSubview(self.changePasswordButton)
        self.view.addSubview(self.labelForOnOff)
        self.view.addSubview(self.labelForMode)
    }

    private func setupConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            switchObjectOnOff.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            switchObjectOnOff.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 50),

            switchObjectForMode.topAnchor.constraint(equalTo: switchObjectOnOff.bottomAnchor, constant: 30),
            switchObjectForMode.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 50),

            changePasswordButton.topAnchor.constraint(equalTo: switchObjectForMode.bottomAnchor, constant: 30),
            changePasswordButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            changePasswordButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 50),

            labelForOnOff.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            labelForOnOff.leadingAnchor.constraint(equalTo: switchObjectOnOff.trailingAnchor, constant: 30),
            labelForOnOff.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),

            labelForMode.topAnchor.constraint(equalTo: switchObjectOnOff.bottomAnchor, constant: 30),
            labelForMode.leadingAnchor.constraint(equalTo: switchObjectForMode.trailingAnchor, constant: 30),
            labelForMode.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16)
        ])
    }
}
