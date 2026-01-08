//
//  MainCoordinator.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 11/8/25.
//

import Foundation
import UIKit

// MARK: - Coordinator Protocol

protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get set }

    func start()
}

// MARK: - Main Coordinator

class MainCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    var tabBarController: UITabBarController

    var feedCoordinator: FeedCoordinator?
    var profileCoordinator: ProfileCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }

    func start() {
        feedCoordinator = FeedCoordinator(navigationController: self.navigationController)
        profileCoordinator = ProfileCoordinator(navigationController: self.navigationController)

        feedCoordinator?.start()
        profileCoordinator?.start()

        let keychainViewController = KeychainViewController()

        let realmMainViewController = RealmMainViewController()

        realmMainViewController.mainNavigationController = self.navigationController

        navigationController.viewControllers = [tabBarController]

        tabBarController.viewControllers = [
            feedCoordinator?.feedViewController ?? UIViewController(),
            profileCoordinator?.logInViewController ?? UIViewController(),
            keychainViewController,
            realmMainViewController
        ]

        tabBarController.selectedIndex = 3
    }
}
