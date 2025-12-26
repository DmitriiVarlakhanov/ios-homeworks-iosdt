//
//  CheckerService.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 12/18/25.
//

import Foundation
import FirebaseAuth

class CheckerService: CheckerServiceProtocol {

    // MARK: - Type methods

    static func checkCredentials(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {

                print(error)

                let alertController = UIAlertController(
                    title: "Authentication Error",
                    message: "\(error.localizedDescription)",
                    preferredStyle: .alert
                )

                let action = UIAlertAction(
                    title: "Ok",
                    style: .cancel
                )

                alertController.addAction(action)

                let topViewController = getTopViewControllerForScene()!

                topViewController.present(alertController, animated: true)

                completion(false)
            }

            if let authResult = authResult {
                completion(true)
            }
        }
    }
    
    static func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)

                let alertController = UIAlertController(
                    title: "Sign up Error",
                    message: "\(error.localizedDescription)",
                    preferredStyle: .alert
                )

                let action = UIAlertAction(
                    title: "Ok",
                    style: .cancel
                )

                alertController.addAction(action)

                let topViewController = getTopViewControllerForScene()!

                topViewController.present(alertController, animated: true)
            } else {
                let alertController = UIAlertController(
                    title: "Success",
                    message: "Signing up is successful",
                    preferredStyle: .alert
                )

                let action = UIAlertAction(
                    title: "Ok",
                    style: .cancel
                )

                alertController.addAction(action)

                let topViewController = getTopViewControllerForScene()!

                topViewController.present(alertController, animated: true)
            }
        }
    }

    private static func getTopViewControllerForScene() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootController = windowScene.windows.first?.rootViewController else {

            return nil
        }

        return findTopViewController(rootController)
    }

    private static func findTopViewController(_ controller: UIViewController) -> UIViewController {
        if let presented = controller.presentedViewController {

            return findTopViewController(presented)
        }

        if let navigation = controller as? UINavigationController {

            return findTopViewController(navigation.visibleViewController ?? navigation)
        }

        if let tab = controller as? UITabBarController {

            return findTopViewController(tab.selectedViewController ?? tab)
        }

        return controller
    }
}
