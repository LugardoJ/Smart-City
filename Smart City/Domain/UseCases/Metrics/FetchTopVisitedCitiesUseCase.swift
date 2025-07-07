//
//  DefaultFetchTopVisitedCitiesUseCase.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
/// Retrieves the most visited cities, based on user interaction history.
///
/// This is used in dashboards or UI widgets to show top destinations.
public protocol FetchTopVisitedCitiesUseCase {
    func execute(limit: Int) -> [(Int, Int)]
}

public final class DefaultTopVisitedCitiesUseCase: FetchTopVisitedCitiesUseCase {
    private let repo: MetricsQuerying

    public init(repo: MetricsQuerying) {
        self.repo = repo
    }

    public func execute(limit: Int = 10) -> [(Int, Int)] {
        repo.fetchTopVisitedCities(limit: limit)
    }
}
