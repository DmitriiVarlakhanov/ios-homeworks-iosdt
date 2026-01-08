//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 11/8/25.
//

import Foundation
import UIKit

class FeedCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    var feedViewController: FeedViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let feedViewModel = FeedViewModel()
        let feedViewController = FeedViewController(feedViewModel: feedViewModel)

        feedViewModel.feedViewController = feedViewController

        feedViewController.tabBarItem = UITabBarItem(
            title: "Feed",
            image: UIImage(systemName: "globe"),
            tag: 1
        )

        self.feedViewController = feedViewController
    }
}
