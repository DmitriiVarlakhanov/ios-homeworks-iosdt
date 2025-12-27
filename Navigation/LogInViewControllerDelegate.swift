//
//  LogInViewControllerDelegate.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 10/12/25.
//

import UIKit

protocol LogInViewControllerDelegate {

    var logInViewContorller: LogInViewController? { get set }

    var checkValue: Bool? { get set }

    func check(login: String, password: String)

    func signUp(login: String, password: String)
}
