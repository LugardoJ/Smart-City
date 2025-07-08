//
//  WikipediaRemoteDataSource.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import Foundation

protocol WikipediaDataSourceProtocol {
    func fetchSummary(for cityName: String) async throws -> CityWikiSummary
}

final class WikipediaRemoteDataSource: WikipediaDataSourceProtocol {
    private let client: NetworkClientProtocol
    private let baseURL = "https://en.wikipedia.org/api/rest_v1/page/summary/"
    
    init(client: NetworkClientProtocol = DefaultNetworkClient()) {
        self.client = client
    }
    
    func fetchSummary(for cityName: String) async throws -> CityWikiSummary {
        guard let encodedCity = cityName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: "\(baseURL)\(encodedCity.replacingOccurrences(of: "%20", with: "_"))")
        else {
            throw URLError(.badURL)
        }
        
        let request = NetworkRequest(url: url)
        return try await client.request(request)
    }
}
