//
//  MetricsRepository.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
import Foundation

public protocol MetricsRecording {
    func recordLoadTime(source: String, duration: TimeInterval)
    func recordSearchTerm(_ term: String)
    func recordCityVisit(cityId: Int)
}

public protocol MetricsQuerying {
    func fetchTopSearchTerms(limit: Int) -> [String]
    func fetchTopVisitedCities(limit: Int) -> [Int]
}
