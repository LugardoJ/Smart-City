//
//  KeychainManagerProtocol.swift
//  Smart City
//
//  Created by Lugardo on 06/07/25.
//
/// A contract that defines secure access to the system Keychain for storing and retrieving sensitive values.
///
/// Conforming types provide basic operations to store, retrieve and delete string values in the iOS Keychain.
/// This abstraction enables mocking and testing across modules while keeping security concerns centralized.
protocol KeychainManagerProtocol {
    /// Stores a string value securely in the Keychain using the given key.
    ///
    /// If a value already exists for the given key, it is overwritten.
    ///
    /// - Parameters:
    ///   - value: The string value to securely store.
    ///   - key: The strongly-typed `KeychainKey` used to identify the stored item.
    /// - Returns: A Boolean indicating whether the save operation succeeded.
    @discardableResult
    func save(_ value: String, for key: KeychainKey) -> Bool

    /// Retrieves a previously stored string value from the Keychain.
    ///
    /// - Parameter key: The strongly-typed `KeychainKey` identifying the desired value.
    /// - Returns: The stored string if it exists, otherwise `nil`.
    func read(for key: KeychainKey) -> String?

    /// Removes a value from the Keychain associated with the given key.
    ///
    /// - Parameter key: The strongly-typed `KeychainKey` of the item to delete.
    /// - Returns: A Boolean indicating whether the delete operation succeeded.
    @discardableResult
    func delete(for key: KeychainKey) -> Bool
}
