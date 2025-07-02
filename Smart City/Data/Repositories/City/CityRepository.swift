//
//  CityRepository.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//

// MARK: - Repository (Data Layer)

protocol CityRepository {
    func searchCities(matching query: String) -> [City]
    func setCities(_ cities: [City])
    func getCitites() -> [City]
    func loadCitiesRemote() async throws
}
