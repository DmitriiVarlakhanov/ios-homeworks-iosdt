//
//  RealmDatabaseEncoded.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 1/25/26.
//

import Foundation
import RealmSwift
import KeychainSwift

final class RealmDatabaseEncoded {

    // MARK: - Type properties

    static let shared = RealmDatabaseEncoded()

    // MARK: - Lifecycle

    private init() {}

    // MARK: - Public

    func setupCustomDatabase() {
        let keychain = KeychainSwift()

        if let encryptionKey = keychain.getData("encryptionKey") {
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

            let customRealmURL = documentsDirectoryURL.appendingPathComponent("myCustomDB.realm")

            let config = Realm.Configuration(fileURL: customRealmURL, encryptionKey: encryptionKey)

            Realm.Configuration.defaultConfiguration = config
        } else {
            var key = Data(count: 64)

            _ = key.withUnsafeMutableBytes { (pointer: UnsafeMutableRawBufferPointer) in
                SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!) }

            keychain.set(key, forKey: "encryptionKey")

            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

            let customRealmURL = documentsDirectoryURL.appendingPathComponent("myCustomDB.realm")

            let config = Realm.Configuration(fileURL: customRealmURL, encryptionKey: key)

            Realm.Configuration.defaultConfiguration = config
        }
    }
}
