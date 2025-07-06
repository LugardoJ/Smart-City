//
//  MockFetchRecentSearchesUseCase.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class MockFetchRecentSearchesUseCase: FetchRecentSearchesUseCase {
    var recentTerms: [String] = ["london", "paris"]
    var deletedTerms: [String] = []

    func execute(limit: Int) -> [String] {
        Array(recentTerms.prefix(limit))
    }

    func delete(_ terms: [String]) {
        deletedTerms = terms
    }
}
