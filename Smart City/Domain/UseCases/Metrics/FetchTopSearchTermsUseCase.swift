//
//  FetchTopSearchTermsUseCase.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
public protocol FetchTopSearchTermsUseCase {
    func execute(limit: Int) -> [String]
}

public final class DefaultFetchTopSearchTermsUseCase: FetchTopSearchTermsUseCase {
    private let repo: MetricsRepository

    public init(repo: MetricsRepository) {
        self.repo = repo
    }

    public func execute(limit: Int = 10) -> [String] {
        repo.fetchTopSearchTerms(limit: limit)
    }
}
