//
//  DefaultKeychainManager.swift
//  Smart City
//
//  Created by Lugardo on 06/07/25.
//
import Foundation
import Security

/// Default implementation of `KeychainManagerProtocol` using Apple's Keychain Services API.
///
/// This class provides methods to store, retrieve and delete string values securely in the iOS Keychain.
/// It conforms to `KeychainManagerProtocol` and is designed to be injected wherever secure storage is needed.
final class DefaultKeychainManager: KeychainManagerProtocol {
    /// Saves a value securely to the Keychain.
    ///
    /// If an item already exists with the same key, it is overwritten.
    ///
    /// - Parameters:
    ///   - value: The string value to store.
    ///   - key: A controlled enum `KeychainKey` identifying the storage location.
    /// - Returns: `true` if the value was successfully stored, `false` otherwise.
    @discardableResult
    func save(_ value: String, for key: KeychainKey) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data,
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        return status == errSecSuccess
    }
    
    /// Reads a stored value from the Keychain.
    ///
    /// - Parameter key: The `KeychainKey` associated with the stored value.
    /// - Returns: The stored string, or `nil` if not found or unreadable.
    func read(for key: KeychainKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8)
        else { return nil }
        
        return string
    }
    
    /// Deletes a value from the Keychain.
    ///
    /// - Parameter key: The `KeychainKey` whose value should be removed.
    /// - Returns: `true` if the item was successfully deleted, `false` otherwise.
    func delete(for key: KeychainKey) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
