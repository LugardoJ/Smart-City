//
//  DefaultFetchLoadTimeMetricsUseCase.swift
//  Smart City
//
//  Created by Lugardo on 03/07/25.
//
import SwiftData
import SwiftUI

public protocol FetchLoadTimeMetricsUseCase {
    func execute() -> [LoadTime]
}

public final class DefaultFetchLoadTimeMetricsUseCase: FetchLoadTimeMetricsUseCase {
    private let context: ModelContextProtocol

    public init(context: ModelContextProtocol) {
        self.context = context
    }

    public func execute() -> [LoadTime] {
        let desc = FetchDescriptor<LoadTimeMetricEntity>(sortBy: [
            SortDescriptor(\.timestamp, order: .forward),
        ])
        let entities = (try? context.fetch(desc)) ?? []
        return entities.map { LoadTime(source: $0.source, duration: $0.duration, timestamp: $0.timestamp) }
    }
}
