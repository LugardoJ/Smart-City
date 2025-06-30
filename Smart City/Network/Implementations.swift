//
//  Implementations.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import Foundation

extension URLSession: NetworkSession {
    
    func data(for request: NetworkRequest) async throws -> (Data, URLResponse) {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        
        request.headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return try await self.data(for: urlRequest)
    }
}
