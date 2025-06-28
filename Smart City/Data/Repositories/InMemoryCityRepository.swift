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
    private var indexedCities: [String: [City]] = [:]
    private let remoteDataSource: CityRemoteDataSourceProtocol
    
    init(remoteDataSource: CityRemoteDataSourceProtocol = CityRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }
    
    func loadCitiesRemote() async throws {
        let loadedCities = try await remoteDataSource.fetchCities()
        self.cities = loadedCities.sorted {
            if $0.name == $1.name {
                return $0.country < $1.country
            }
            return $0.name < $1.name
        }
        indexCities()
    }
    
    private func indexCities() {
        indexedCities = [:]
        for city in cities {
            let prefix = String(city.name.prefix(1)).lowercased()
            indexedCities[prefix, default: []].append(city)
        }
    }
    
    func searchCities(matching query: String) -> [City] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if q.isEmpty {
            return cities
        }
        
        guard let firstChar = q.first else { return [] }
        
        return indexedCities[String(firstChar), default: []]
            .filter { $0.name.lowercased().hasPrefix(q) }
            .sorted {
                if $0.name == $1.name {
                    return $0.country < $1.country
                }
                return $0.name < $1.name
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
