//
//  ModelContext+Cities.swift
//  Smart City
//
//  Created by Lugardo on 28/06/25.
//
import SwiftData

@MainActor
extension ModelContext {
    func cacheCities(_ cities: [City]) throws {
        let old = try fetch(FetchDescriptor<CityEntity>())
        old.forEach(delete)
        cities.map(CityEntity.fromDomain).forEach(insert)
        try save()
    }

    func fetchCachedCities() -> [City] {
        let entities = (try? fetch(FetchDescriptor<CityEntity>())) ?? []
        return entities.map(\.toDomain)
    }

    func isCityCacheEmpty() -> Bool {
        ((try? fetchCount(FetchDescriptor<CityEntity>())) ?? 0) == 0
    }
}
