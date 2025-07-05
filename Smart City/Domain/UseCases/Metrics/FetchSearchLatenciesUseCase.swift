//
//  FetchSearchLatenciesUseCase.swift
//  Smart City
//
//  Created by Lugardo on 03/07/25.
//
import Foundation

public protocol FetchSearchLatenciesUseCase {
    func execute(limit: Int) -> [SearchLatency]
}

public struct DefaultFetchSearchLatenciesUseCase: FetchSearchLatenciesUseCase {
    private let repo: MetricsQuerying
    public init(repo: MetricsQuerying) { self.repo = repo }

    public func execute(limit: Int = 30) -> [SearchLatency] {
        repo.fetchSearchLatencies(limit: limit)
    }
}
