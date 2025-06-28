//
//  CityRepository.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
// MARK: - Repository (Data Layer)

protocol CityRepository {
    func searchCities(matching query: String) -> [City]
    func toggleFavorite(_ city: City)
    func isFavorite(_ city: City) -> Bool
    func favorites() -> [City]
    
    func loadCitiesRemote() async throws
}
