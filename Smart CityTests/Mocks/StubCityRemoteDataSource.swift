//
//  StubCityRemoteDataSource.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
import Foundation
@testable import Smart_City

/// Simula el protocolo de RemoteDataSource devolviendo siempre las mismas ciudades.
final class StubCityRemoteDataSource: CityRemoteDataSourceProtocol {
    private let cities: [City]
    
    init(cities: [City]) {
        self.cities = cities
    }

    func fetchCities() async throws -> [City] {
        return cities
    }
}
