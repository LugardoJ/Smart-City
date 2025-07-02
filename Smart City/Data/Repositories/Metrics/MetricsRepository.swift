//
//  MetricsRepository.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
import Foundation

public protocol MetricsRepository {
    // Load times
    func recordLoadTime(source: String, duration: TimeInterval)
    // Search metrics
    func recordSearchTerm(_ term: String)
    func fetchTopSearchTerms(limit: Int) -> [String]
    // Visit metrics
    func recordCityVisit(cityId: Int)
    func fetchTopVisitedCities(limit: Int) -> [Int]
}
