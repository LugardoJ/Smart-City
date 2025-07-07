//
//  AppInitializer.swift
//  Smart City
//
//  Created by Lugardo on 06/07/25.
//
import Foundation

struct AppInitializer {
    private let keychain: KeychainManagerProtocol

    init(keychain: KeychainManagerProtocol = DefaultKeychainManager()) {
        self.keychain = keychain
    }

    func setup() {
        if keychain.read(for: .amplitudeAPIKey) == nil {
            _ = keychain.save("d6b6f84cbc0bd82a3bc5a73a87306739", for: .amplitudeAPIKey)
        }
    }
}
