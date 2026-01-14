//
//  ExtensionUIViewController.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 1/14/26.
//

import UIKit

extension UIViewController {

    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }

        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }

        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }

        return self
    }
}
