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
    
    private let client: NetworkClientProtocol
    
    private static let citiesURLString = """
    https://gist.githubusercontent.com/hernan-uala/\
    dce8843a8edbe0b0018b32e137bc2b3a/raw/\
    0996accf70cb0ca0e16f9a99e0ee185fafca7af1/\
    cities.json
    """
    
    private static let citiesURL: URL = {
        guard let url = URL(string: citiesURLString) else {
            fatalError("Invalid cities URL")
        }
        return url
    }()
    
    init(client: NetworkClientProtocol = DefaultNetworkClient()) {
        self.client = client
    }
    
    func fetchCities() async throws -> [City] {
        let request = NetworkRequest(url: Self.citiesURL)
        return try await client.request(request)
    }
}
