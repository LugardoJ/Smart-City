//
//  MockMetricsQueryRepository.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
import Foundation
@testable import Smart_City

final class MockMetricsQueryRepository: MetricsQuerying {
    var topSearchTerms: [(String, Int)] = [
        ("paris", 10),
        ("london", 8),
    ]

    var topVisitedCities: [(Int, Int)] = [
        (1, 5),
        (2, 3),
    ]

    var latencies: [SearchLatency] = [
        SearchLatency(query: "test", duration: 0.25, timestamp: Date()),
    ]

    func fetchTopSearchTerms(limit: Int) -> [(String, Int)] {
        Array(topSearchTerms.prefix(limit))
    }

    func fetchSearchLatencies(limit: Int) -> [SearchLatency] {
        Array(latencies.prefix(limit))
    }

    func fetchTopVisitedCities(limit: Int) -> [(Int, Int)] {
        Array(topVisitedCities.prefix(limit))
    }
}
