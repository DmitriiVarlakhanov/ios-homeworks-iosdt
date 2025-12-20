//
//  LogInInspector.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 10/12/25.
//

import UIKit

class LogInInspector: LogInViewControllerDelegate {

    // MARK: - Public

    func check(login: String, password: String) -> Bool {
        CheckerService.checkCredentials(email: login, password: password)

        return Checker.shared.check(login: login, password: password)
    }

    func signUp(login: String, password: String) {
        CheckerService.signUp(email: login, password: password)
    }
}
