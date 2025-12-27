//
//  LogInInspector.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 10/12/25.
//

import UIKit

class LogInInspector: LogInViewControllerDelegate {

    weak var logInViewContorller: LogInViewController?

    var checkValue: Bool? {
        willSet {
            if newValue! {
                let user = User(
                    login: logInViewContorller!.emailOrPhoneTextField.text ?? "",
                    fullName: logInViewContorller!.emailOrPhoneTextField.text ?? "",
                    avatar: UIImage(systemName: "person.crop.circle")!,
                    status: "Test status"
                )

                let profileViewController = ProfileViewController()

                profileViewController.user = user

                logInViewContorller!.profileCoordinator?.goToProfileViewController(profileViewController: profileViewController)
            }
        }
    }

    // MARK: - Public

    func check(login: String, password: String) {
        CheckerService.checkCredentials(email: login, password: password) { boolValue in
            self.checkValue = boolValue
        }
    }

    func signUp(login: String, password: String) {
        CheckerService.signUp(email: login, password: password)
    }
}
