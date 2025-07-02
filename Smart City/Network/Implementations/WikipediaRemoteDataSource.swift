//
//  WikipediaRemoteDataSource.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import Foundation

protocol WikipediaRemoteDataSourceProtocol {
    func fetchSummary(for cityName: String) async throws -> CityWikiSummary
}

final class WikipediaRemoteDataSource: WikipediaRemoteDataSourceProtocol {
    private let session: NetworkSession
    private let decoder: JSONDecoder
    private let baseURL = "https://\(Locale.current.language.languageCode?.identifier ?? "en").wikipedia.org/api/rest_v1/page/summary/"

    init(session: NetworkSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func fetchSummary(for cityName: String) async throws -> CityWikiSummary {
        guard let encodedCity = cityName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: "\(baseURL)\(encodedCity.replacingOccurrences(of: "%20", with: "_"))") else {
            throw URLError(.badURL)
        }

        let request = NetworkRequest(url: url)
        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try decoder.decode(CityWikiSummary.self, from: data)
    }
}
