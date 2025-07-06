//
//  MockModelContext.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import SwiftData
import XCTest

final class MockModelContext: ModelContextProtocol {
    private var cachedCities: [City] = []

    func isCityCacheEmpty() -> Bool {
        cachedCities.isEmpty
    }

    func fetchCachedCities() -> [City] {
        cachedCities
    }

    func fetchBackgroundCachedCities() -> [City] {
        cachedCities
    }

    func fetchCachedCities(offset: Int = 0, limit: Int = 10000) -> [City] {
        let sorted = cachedCities.sorted(by: { $0.name < $1.name })
        let end = min(offset + limit, sorted.count)
        guard offset < sorted.count else { return [] }
        return Array(sorted[offset ..< end])
    }

    func cacheCities(_ cities: [City]) throws {
        cachedCities = cities
    }

    func fetch<T>(_ descriptor: FetchDescriptor<T>) throws -> [T] where T: PersistentModel {
        []
    }

    func fetchCount(_ descriptor: FetchDescriptor<some PersistentModel>) throws -> Int {
        0
    }
}
