//
//  InMemoryCityRepository.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
// MARK: - Repository (Data Layer)

final class InMemoryCityRepository: CityRepository {
    private var cities: [City] = []
    private var indexedCities: [String: [City]] = [:]
    private let remoteDataSource: CityRemoteDataSourceProtocol

    init(remoteDataSource: CityRemoteDataSourceProtocol = CityRemoteDataSource()){
        self.remoteDataSource = remoteDataSource
    }
    
    func setCities(_ cities: [City]) {
        self.cities = cities.sorted(by: citySort)
        indexCities()
    }
    
    func loadCitiesRemote() async throws {
        let loadedCities = try await remoteDataSource.fetchCities()
        setCities(loadedCities)
    }
    
    private func indexCities() {
        indexedCities = [:]
        for city in cities {
            let prefix = String(city.name.prefix(1)).lowercased()
            indexedCities[prefix, default: []].append(city)
        }
    }
    
    func getCitites() -> [City] {
        self.cities
    }
    
    func searchCities(matching query: String) -> [City] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return cities }
        guard let firstChar = q.first else { return [] }
        
        return indexedCities[String(firstChar), default: []]
            .filter { $0.name.lowercased().hasPrefix(q) }
            .sorted(by: citySort)
    }
    
    private func citySort(lhs: City, rhs: City) -> Bool {
        lhs.name == rhs.name ? lhs.country < rhs.country : lhs.name < rhs.name
    }
    
}
