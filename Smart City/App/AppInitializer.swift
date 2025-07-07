//
//  AppInitializer.swift
//  Smart City
//
//  Created by Lugardo on 06/07/25.
//
import Foundation

/// A centralized class responsible for executing one-time setup routines at app launch.
///
/// `AppInitializer` is typically invoked from the `@main` entry point of the app.
/// It handles tasks like setting up API keys, bootstrapping services, and preparing environment configurations.
///
/// This struct encapsulates early configuration logic to ensure a clean separation between the app's
/// startup lifecycle and feature logic.
struct AppInitializer {
    /// The Keychain service used to store or retrieve secure tokens like API keys.
    private let keychain: KeychainManagerProtocol

    /// Initializes the initializer with a concrete or mock keychain manager.
    ///
    /// - Parameter keychain: A concrete implementation of `KeychainManagerProtocol`. Defaults to `DefaultKeychainManager`.
    init(keychain: KeychainManagerProtocol = DefaultKeychainManager()) {
        self.keychain = keychain
    }

    /// Performs all one-time setup routines required before the app becomes usable.
    ///
    /// This includes ensuring that the Amplitude API key is stored in the Keychain.
    /// This method is designed to be idempotent and safe to call multiple times if needed.
    func setup() {
        if keychain.read(for: .amplitudeAPIKey) == nil {
            keychain.save("d6b6f84cbc0bd82a3bc5a73a87306739", for: .amplitudeAPIKey)
        }
    }
}
