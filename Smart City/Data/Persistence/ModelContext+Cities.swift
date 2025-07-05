//
//  ModelContext+Cities.swift
//  Smart City
//
//  Created by Lugardo on 28/06/25.
//
import Foundation
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
        let descriptor = FetchDescriptor<CityEntity>()
        let entities = (try? fetch(descriptor)) ?? []
        return entities.map(\.toDomain)
    }

    func fetchBackgroundCachedCities() -> [City] {
        let descriptor = FetchDescriptor<CityEntity>()
        let entities = (try? fetch(descriptor)) ?? []
        return entities.map(\.toDomain)
    }

    func fetchCachedCities(offset: Int = 0, limit: Int = 10000) -> [City] {
        var descriptor = FetchDescriptor<CityEntity>(
            sortBy: [SortDescriptor(\.name)]
        )
        descriptor.fetchOffset = offset
        descriptor.fetchLimit = limit

        do {
            let entities = try fetch(descriptor)
            return entities.map(\.toDomain)
        } catch {
            print("🔴 Error fetching cached cities: \(error)")
            return []
        }
    }

    func isCityCacheEmpty() -> Bool {
        ((try? fetchCount(FetchDescriptor<CityEntity>())) ?? 0) == 0
    }
}
