//
//  CheckerServiceProtocol.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 12/18/25.
//

import Foundation

protocol CheckerServiceProtocol {

    // MARK: - Type methods

    static func checkCredentials(email: String, password: String) -> Void

    static func signUp(email: String, password: String)
}
