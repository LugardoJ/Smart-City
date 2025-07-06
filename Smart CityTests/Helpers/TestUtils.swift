//
//  TestUtils.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

// MARK: - Helpers

extension MockMetricsQueryRepository {
    static func withTopTerms() -> MockMetricsQueryRepository {
        let repo = MockMetricsQueryRepository()
        repo.topSearchTerms = [("paris", 10), ("tokyo", 9)]
        return repo
    }

    static func withTopCities() -> MockMetricsQueryRepository {
        let repo = MockMetricsQueryRepository()
        repo.topVisitedCities = [(101, 5), (102, 3)]
        return repo
    }

    static func withLatencies() -> MockMetricsQueryRepository {
        let repo = MockMetricsQueryRepository()
        repo.latencies = [
            SearchLatency(query: "rome", duration: 0.4, timestamp: Date()),
            SearchLatency(query: "berlin", duration: 0.6, timestamp: Date()),
        ]
        return repo
    }
}

extension MockToggleFavoriteCityUseCase {
    static func withFavorites() -> MockToggleFavoriteCityUseCase {
        let uc = MockToggleFavoriteCityUseCase()
        uc.favorites = [City.mock(id: 1, name: "Mock Fav", country: "Mockland", isFavorite: true)]
        return uc
    }
}

extension InMemoryCityRepository {
    static func stubbedWithCities() -> InMemoryCityRepository {
        let repo = InMemoryCityRepository(remoteDataSource: DummyCityRemoteDataSource())
        let cities = [
            City.mock(id: 101, name: "City A"),
            City.mock(id: 102, name: "City B"),
        ]
        repo.setCities(cities)
        return repo
    }
}
