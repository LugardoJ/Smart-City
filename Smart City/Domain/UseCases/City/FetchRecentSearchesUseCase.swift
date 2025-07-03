//
//  FetchRecentSearchesUseCase.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
public protocol FetchRecentSearchesUseCase {
    func execute(limit: Int) -> [String]
    func delete(_ terms: [String])
}

public final class DefaultFetchSearchesUseCase: FetchRecentSearchesUseCase {
    private let historyRepo: SearchHistoryRepository

    public init(historyRepo: SearchHistoryRepository) {
        self.historyRepo = historyRepo
    }

    public func execute(limit: Int = 8) -> [String] {
        historyRepo.fetchRecentSearches(limit: limit).map(\.term)
    }

    public func delete(_ terms: [String]) {
        historyRepo.deleteQueries(terms)
    }
}
