//
//  CityRepository.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//

/// Abstraction for city data access, allowing in-memory or persistent strategies.
///
/// Implementations handle city loading, indexing, and favorite status resolution.
public protocol CityRepository {
    func searchCities(matching query: String) -> [City]
    func setCities(_ cities: [City])
    func getCitites() -> [City]
    func loadCitiesRemote() async throws
}
