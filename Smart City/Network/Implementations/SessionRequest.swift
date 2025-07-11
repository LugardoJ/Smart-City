//
//  Implementations.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import Foundation

public enum NetworkRequestType: String {
    case GET
    case POST
    case PUT
}

public struct NetworkRequest {
    let url: URL
    let method: NetworkRequestType
    let headers: [String: String]

    init(url: URL, method: NetworkRequestType = .GET, headers: [String: String] = [:]) {
        self.url = url
        self.method = method
        self.headers = headers
    }
}

public protocol NetworkSession {
    func data(for request: NetworkRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {
    public func data(for request: NetworkRequest) async throws -> (Data, URLResponse) {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue

        for (key, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return try await data(for: urlRequest)
    }
}
