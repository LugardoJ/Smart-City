//
//  DefaultFetchTopVisitedCitiesUseCase.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
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
