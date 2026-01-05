//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 11/8/25.
//

import Foundation
import UIKit

class ProfileCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    var logInViewController: LogInViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let logInViewController = LogInViewController()

        logInViewController.profileCoordinator = self

        logInViewController.logInDelegate = MyLogInFactory().makeLogInInspector()

        logInViewController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.crop.circle"),
            tag: 2
        )

        self.logInViewController = logInViewController

        self.logInViewController?.profileCoordinator = self
    }

    func goToProfileViewController(profileViewController: ProfileViewController) {

        self.navigationController.pushViewController(profileViewController, animated: true)
    }
}
