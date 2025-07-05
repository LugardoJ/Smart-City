//
//  MockCityRepository.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
import Foundation
@testable import Smart_City

final class MockCityRepository: CityRepository {
    private var storage: [City] = []
    var didLoadRemote = false
    var shouldThrowOnLoad = false

    func searchCities(matching query: String) -> [City] {
        storage.filter { $0.name.lowercased().contains(query.lowercased()) }
    }

    func setCities(_ cities: [City]) {
        storage = cities
    }

    func getCitites() -> [City] {
        storage
    }

    func loadCitiesRemote() async throws {
        didLoadRemote = true
        if shouldThrowOnLoad {
            throw URLError(.notConnectedToInternet)
        }
    }
}
