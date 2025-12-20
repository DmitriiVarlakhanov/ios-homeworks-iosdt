//
//  LogInViewControllerDelegate.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 10/12/25.
//

import UIKit

protocol LogInViewControllerDelegate {

    func check(login: String, password: String) -> Bool

    func signUp(login: String, password: String)
}
