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
    private let url = URL(string: "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json")!

    func fetchCities() async throws -> [City] {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([City].self, from: data)
    }
}
