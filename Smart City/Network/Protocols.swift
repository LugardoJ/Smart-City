//
//  Protocols.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import Foundation

protocol NetworkSession {
    func data(for request: NetworkRequest) async throws -> (Data, URLResponse)
}
