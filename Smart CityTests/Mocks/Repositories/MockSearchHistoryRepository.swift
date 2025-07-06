//
//  MockSearchHistoryRepository.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class MockSearchHistoryRepository: SearchHistoryRepository {
    var registeredTerms: [String] = []
    func registerQuery(term: String) {
        registeredTerms.append(term)
    }

    func fetchRecentSearches(limit: Int) -> [SearchHistoryEntity] {
        []
    }

    func fetchMostSearched(limit: Int) -> [SearchHistoryEntity] {
        []
    }

    func clearHistory() {}

    func deleteQueries(_ terms: [String]) {}
}
