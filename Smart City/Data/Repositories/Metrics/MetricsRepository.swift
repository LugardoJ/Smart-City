//
//  MetricsRepository.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
import Foundation

/// Defines how metrics like load time, search latency, and visit events are tracked and retrieved.
///
/// Use this protocol to separate analytics from core logic.
public protocol MetricsRecording {
    func recordLoadTime(source: String, duration: TimeInterval)
    func recordSearchTerm(_ term: String)
    func recordSearchLatency(query: String, duration: TimeInterval)
    func recordCityVisit(cityId: Int)
    func recordTimeInScreen(name: String, duration: TimeInterval)
}

public protocol MetricsQuerying {
    func fetchTopSearchTerms(limit: Int) -> [(String, Int)]
    func fetchSearchLatencies(limit: Int) -> [SearchLatency]
    func fetchTopVisitedCities(limit: Int) -> [(Int, Int)]
}
