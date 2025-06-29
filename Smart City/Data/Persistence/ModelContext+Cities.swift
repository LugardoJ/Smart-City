//
//  ModelContext+Cities.swift
//  Smart City
//
//  Created by Lugardo on 28/06/25.
//
import SwiftData

extension ModelContext {
    func cacheCities(_ cities: [City]) throws {
        let old = try self.fetch(FetchDescriptor<CityEntity>())
        old.forEach(self.delete)
        cities.map(CityEntity.fromDomain).forEach(self.insert)
        try self.save()
    }

    func fetchCachedCities() -> [City] {
        let entities = (try? self.fetch(FetchDescriptor<CityEntity>())) ?? []
        return entities.map { $0.toDomain }
    }

    func isCityCacheEmpty() -> Bool {
        ((try? self.fetchCount(FetchDescriptor<CityEntity>())) ?? 0) == 0
    }
}
