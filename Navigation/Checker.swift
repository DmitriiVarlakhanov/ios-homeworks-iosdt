//
//  Checker.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 10/11/25.
//

import UIKit

class Checker {

    static let shared: Checker = {
        let instatnce = Checker()

        return instatnce
    }()

    private let login: String = "test@gmail.com"
    private let password: String = "123456"

    private init() {}

    func check(login: String, password: String) -> Bool {
        if self.login == login && self.password == password {
            return true
        } else {
            return false
        }
    }
}
