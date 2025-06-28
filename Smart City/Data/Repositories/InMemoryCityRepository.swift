//
//  InMemoryCityRepository.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
// MARK: - Repository (Data Layer)

final class InMemoryCityRepository: CityRepository {
    private var cities: [City] = []
    private var favoritesSet: Set<Int> = []
    private let remoteDataSource: CityRemoteDataSourceProtocol

    init(remoteDataSource: CityRemoteDataSourceProtocol = CityRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }
    
    func loadCitiesRemote() async throws {
        self.cities = try await remoteDataSource.fetchCities()
    }
    
    func searchCities(matching query: String) -> [City] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return cities.filter {
            $0.name.lowercased().hasPrefix(trimmed)
        }.sorted { a, b in
            if a.name == b.name {
                return a.country < b.country
            }
            return a.name < b.name
        }
    }

    func toggleFavorite(_ city: City) {
        if favoritesSet.contains(city.id) {
            favoritesSet.remove(city.id)
        } else {
            favoritesSet.insert(city.id)
        }
    }

    func isFavorite(_ city: City) -> Bool {
        favoritesSet.contains(city.id)
    }

    func favorites() -> [City] {
        cities.filter { favoritesSet.contains($0.id) }
    }
}
