//
//  DefaultFetchTopSearchTermsUseCase.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
/// Retrieves the most frequently searched terms from local metric storage.
///
/// Used in the metrics dashboard to highlight user interest and trends.
public protocol FetchTopSearchTermsUseCase {
    func execute(limit: Int) -> [(String, Int)]
}

public final class DefaultTopSearchTermsUseCase: FetchTopSearchTermsUseCase {
    private let repo: MetricsQuerying

    public init(repo: MetricsQuerying) {
        self.repo = repo
    }

    public func execute(limit: Int = 40) -> [(String, Int)] {
        repo.fetchTopSearchTerms(limit: limit)
    }
}
