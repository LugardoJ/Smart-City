//
//  CityRemoteDataSource.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
import Foundation

protocol CityRemoteDataSourceProtocol {
    func fetchCities() async throws -> [City]
}

final class CityRemoteDataSource: CityRemoteDataSourceProtocol {
    private let session: NetworkSession
    private let decoder: JSONDecoder
    private let request: NetworkRequest

    private static let citiesURL = URL(string: "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json")!

    init(request: NetworkRequest = NetworkRequest(url: citiesURL),session: NetworkSession = URLSession.shared,decoder: JSONDecoder = JSONDecoder()) {
        self.request = request
        self.session = session
        self.decoder = decoder
    }

    func fetchCities() async throws -> [City] {
        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try decoder.decode([City].self, from: data)
    }
}
