//
//  SwiftDataCityRepository.swift
//  Smart City
//
//  Created by Lugardo on 28/06/25.
//
import SwiftData
import SwiftUI

final class SwiftDataCityRepository: CityRepository {
    private let context: ModelContext
    private let remoteDataSource: CityRemoteDataSourceProtocol

    init(context: ModelContext, remoteDataSource: CityRemoteDataSourceProtocol = CityRemoteDataSource()) {
        self.context = context
        self.remoteDataSource = remoteDataSource
    }

    func loadCitiesRemote() async throws {
        let cities = try await remoteDataSource.fetchCities()
        try context.cacheCities(cities)
    }

    func setCities(_ cities: [City]) {
        do{
            try context.cacheCities(cities)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func getCitites() -> [City] {
        context.fetchCachedCities()
    }
    
    func searchCities(matching query: String) -> [City] {
        let cities = context.fetchCachedCities()
        let q = query.trimmingCharacters(in: .newlines).lowercased()
        guard !q.isEmpty else { return cities.sorted(by: citySort) }

        return cities
            .filter { $0.name.lowercased().hasPrefix(q) }
            .sorted(by: citySort)
    }

    func toggleFavorite(_ city: City) {
        let descriptor = FetchDescriptor<CityEntity>(predicate: #Predicate { $0.id == city.id })
        if let entity = try? context.fetch(descriptor).first {
            entity.isFavorite.toggle()
            try? context.save()
        }
    }

    func isFavorite(_ city: City) -> Bool {
        let descriptor = FetchDescriptor<CityEntity>(predicate: #Predicate { $0.id == city.id })
        return (try? context.fetch(descriptor).first?.isFavorite) ?? false
    }

    func favorites() -> [City] {
        let descriptor = FetchDescriptor<CityEntity>(predicate: #Predicate { $0.isFavorite == true })
        let entities = (try? context.fetch(descriptor)) ?? []
        return entities.map { $0.toDomain }
    }

    private func citySort(lhs: City, rhs: City) -> Bool {
        lhs.name == rhs.name ? lhs.country < rhs.country : lhs.name < rhs.name
    }
}
