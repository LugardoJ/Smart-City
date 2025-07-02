//
//  FetchTopVisitedCitiesUseCase.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
public protocol FetchTopVisitedCitiesUseCase {
    func execute(limit: Int) -> [Int]
}

public final class DefaultFetchTopVisitedCitiesUseCase: FetchTopVisitedCitiesUseCase {
    private let repo: MetricsRepository

    public init(repo: MetricsRepository) {
        self.repo = repo
    }

    public func execute(limit: Int = 10) -> [Int] {
        repo.fetchTopVisitedCities(limit: limit)
    }
}
