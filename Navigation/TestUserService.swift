//
//  TestUserService.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 10/6/25.
//

import UIKit

class TestUserService: UserService {

    var testUser: User? = User(
        login: "test@gmail.com",
        fullName: "Test Name",
        avatar: UIImage(systemName: "person.crop.circle")!,
        status: "Test Status"
    )

    func loginCheck(login: String) -> User? {
        if login == self.testUser?.login {
            return self.testUser
        } else {
            return nil
        }
    }
}
