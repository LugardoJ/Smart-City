//
//  NetworkClient.swift
//  Smart City
//
//  Created by Lugardo on 07/07/25.
//
import Foundation

public protocol NetworkClientProtocol {
    func request<T: Decodable>(_ request: NetworkRequest) async throws -> T
}

public final class DefaultNetworkClient: NetworkClientProtocol {
    private let session: NetworkSession
    private let decoder: JSONDecoder

    public init(
        session: NetworkSession = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    public func request<T: Decodable>(_ request: NetworkRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try decoder.decode(T.self, from: data)
    }
}
