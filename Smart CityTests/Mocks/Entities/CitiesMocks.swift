//
//  CitiesMocks.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

// MARK: - City mocks

extension City {
    static func mock(
        id: Int = Int.random(in: 1 ... 1000),
        name: String = "Mock City",
        country: String = "Mockland",
        coord: City.Coordinate = City.Coordinate(lon: 0.0, lat: 0.0),
        isFavorite: Bool = false
    ) -> City {
        City(id: id, name: name, country: country, coord: coord, isFavorite: isFavorite)
    }
}

final class DummyCityRemoteDataSource: CityRemoteDataSourceProtocol {
    func fetchCities() async throws -> [City] {
        [City.mock(name: "Remote City")]
    }
}
