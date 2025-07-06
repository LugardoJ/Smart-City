//
//  SwiftDataMetricsRepository.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
import SwiftData
import SwiftUI

public final class SwiftDataMetricsRecorder: MetricsRecording {
    private let context: ModelContext

    public init(context: ModelContext) {
        self.context = context
    }

    // MARK: – Load Time

    public func recordLoadTime(source: String, duration: TimeInterval) {
        let entity = LoadTimeMetricEntity(source: source, duration: duration)
        context.insert(entity)
        try? context.save()
    }

    // MARK: – Watching Screen Time

    public func recordTimeInScreen(name: String, duration: TimeInterval) {
        let entity = LoadTimeMetricEntity(source: name, duration: duration)
        context.insert(entity)
        try? context.save()
    }

    // MARK: – Search Term

    public func recordSearchTerm(_ term: String) {
        let desc = FetchDescriptor<SearchMetricEntity>(predicate: #Predicate { $0.term == term })
        if let existing = try? context.fetch(desc).first {
            existing.record()
        } else {
            context.insert(SearchMetricEntity(term: term))
        }
        try? context.save()
    }

    // MARK: – Capture search time

    public func recordSearchLatency(query: String, duration: TimeInterval) {
        context.insert(SearchLatencyEntity(
            query: query,
            duration: duration
        ))
        try? context.save()
    }

    // MARK: – City Visits

    public func recordCityVisit(cityId: Int) {
        let desc = FetchDescriptor<VisitMetricEntity>(predicate: #Predicate { $0.cityId == cityId })
        if let existing = try? context.fetch(desc).first {
            existing.record()
        } else {
            context.insert(VisitMetricEntity(cityId: cityId))
        }
        try? context.save()
    }
}

public final class SwiftDataMetricsQueryRepository: MetricsQuerying {
    private let context: ModelContextProtocol

    public init(context: ModelContextProtocol) {
        self.context = context
    }

    public func fetchTopSearchTerms(limit: Int = 10) -> [(String, Int)] {
        let desc = FetchDescriptor<SearchMetricEntity>(
            sortBy: [SortDescriptor(\.count, order: .reverse)]
        )
        return (try? context.fetch(desc))?
            .prefix(limit)
            .map { ($0.term, $0.count) } ?? []
    }

    public func fetchSearchLatencies(limit: Int) -> [SearchLatency] {
        let desc = FetchDescriptor<SearchLatencyEntity>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return (try? context.fetch(desc))?
            .prefix(limit)
            .map { SearchLatency(query: $0.query, duration: $0.duration, timestamp: $0.timestamp) } ?? []
    }

    public func fetchTopVisitedCities(limit: Int = 10) -> [(Int, Int)] {
        let desc = FetchDescriptor<VisitMetricEntity>(
            sortBy: [SortDescriptor(\.count, order: .reverse)]
        )
        return (try? context.fetch(desc))?
            .prefix(limit)
            .map { ($0.cityId, $0.count) } ?? []
    }
}
