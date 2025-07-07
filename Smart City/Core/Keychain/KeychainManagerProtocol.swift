//
//  KeychainManagerProtocol.swift
//  Smart City
//
//  Created by Lugardo on 06/07/25.
//
protocol KeychainManagerProtocol {
    func save(_ value: String, for key: KeychainKey) -> Bool
    func read(for key: KeychainKey) -> String?
    func delete(for key: KeychainKey) -> Bool
}
