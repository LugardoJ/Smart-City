//
//  ModelContext+Cities.swift
//  Smart City
//
//  Created by Lugardo on 28/06/25.
//
import Foundation
import SwiftData

public protocol ModelContextProtocol: AnyObject {
    // City cache helpers
    func isCityCacheEmpty() -> Bool
    func fetchCachedCities() -> [City]
    func fetchBackgroundCachedCities() -> [City]
    func fetchCachedCities(offset: Int, limit: Int) -> [City]
    func cacheCities(_ cities: [City]) throws

    // SwiftData access
    func fetch<T>(_ descriptor: FetchDescriptor<T>) throws -> [T] where T: PersistentModel
    func fetchCount(_ descriptor: FetchDescriptor<some PersistentModel>) throws -> Int
}

extension ModelContext: ModelContextProtocol {
    public func isCityCacheEmpty() -> Bool {
        ((try? fetchCount(FetchDescriptor<CityEntity>())) ?? 0) == 0
    }

    public func fetchCachedCities() -> [City] {
        let descriptor = FetchDescriptor<CityEntity>()
        let entities = (try? fetch(descriptor)) ?? []
        return entities.map(\..toDomain)
    }

    public func fetchBackgroundCachedCities() -> [City] {
        let descriptor = FetchDescriptor<CityEntity>()
        let entities = (try? fetch(descriptor)) ?? []
        return entities.map(\..toDomain)
    }

    public func fetchCachedCities(offset: Int = 0, limit: Int = 10000) -> [City] {
        var descriptor = FetchDescriptor<CityEntity>(
            sortBy: [SortDescriptor(\CityEntity.name)]
        )
        descriptor.fetchOffset = offset
        descriptor.fetchLimit = limit

        do {
            let entities = try fetch(descriptor)
            return entities.map(\..toDomain)
        } catch {
            print("🔴 Error fetching cached cities: \(error)")
            return []
        }
    }

    public func cacheCities(_ cities: [City]) throws {
        let old = try fetch(FetchDescriptor<CityEntity>())
        old.forEach(delete)
        cities.map(CityEntity.fromDomain).forEach(insert)
        try save()
    }
}
