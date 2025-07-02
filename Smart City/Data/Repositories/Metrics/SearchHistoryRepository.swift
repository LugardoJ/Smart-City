//
//  SearchHistoryRepository.swift
//  Smart City
//
//  Created by Lugardo on 30/06/25.
//
import SwiftData
import SwiftUI

protocol SearchHistoryRepository {
    func recordSearch(for city: City)
    func fetchMostSearched(limit: Int) -> [SearchHistoryEntity]
    func fetchRecentSearches(limit: Int) -> [SearchHistoryEntity]

    func registerQuery(term: String)
    func fetchMostQueried(limit: Int) -> [SearchQueryHistoryEntity]
    func fetchRecentQueries(limit: Int) -> [SearchQueryHistoryEntity]
}

final class SwiftDataSearchHistoryRepository: SearchHistoryRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - City-Based Search History

    func recordSearch(for city: City) {
        let descriptor = FetchDescriptor<SearchHistoryEntity>(
            predicate: #Predicate { $0.cityId == city.id }
        )

        if let existing = try? context.fetch(descriptor).first {
            existing.updateSearchStats()
        } else {
            let newEntry = SearchHistoryEntity(
                cityId: city.id,
                cityName: city.name,
                country: city.country
            )
            context.insert(newEntry)
        }
    }

    func fetchMostSearched(limit: Int = 10) -> [SearchHistoryEntity] {
        let descriptor = FetchDescriptor<SearchHistoryEntity>(
            sortBy: [SortDescriptor(\.searchCount, order: .reverse)]
        )
        return (try? context.fetch(descriptor))?.prefix(limit).map { $0 } ?? []
    }

    func fetchRecentSearches(limit: Int = 10) -> [SearchHistoryEntity] {
        let descriptor = FetchDescriptor<SearchHistoryEntity>(
            sortBy: [SortDescriptor(\.lastSearchedAt, order: .reverse)]
        )
        return (try? context.fetch(descriptor))?.prefix(limit).map { $0 } ?? []
    }

    // MARK: - Query-Term Based History

    func registerQuery(term: String) {
        let trimmed = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 4 else { return }

        let descriptor = FetchDescriptor<SearchQueryHistoryEntity>(
            predicate: #Predicate { $0.term == trimmed }
        )

        if let existing = try? context.fetch(descriptor).first {
            existing.updateSearchStats()
        } else {
            let newEntry = SearchQueryHistoryEntity(term: trimmed)
            context.insert(newEntry)
        }
    }

    func fetchMostQueried(limit: Int = 10) -> [SearchQueryHistoryEntity] {
        let descriptor = FetchDescriptor<SearchQueryHistoryEntity>(
            sortBy: [SortDescriptor(\.searchCount, order: .reverse)]
        )
        return (try? context.fetch(descriptor))?.prefix(limit).map { $0 } ?? []
    }

    func fetchRecentQueries(limit: Int = 10) -> [SearchQueryHistoryEntity] {
        let descriptor = FetchDescriptor<SearchQueryHistoryEntity>(
            sortBy: [SortDescriptor(\.lastSearchedAt, order: .reverse)]
        )
        return (try? context.fetch(descriptor))?.prefix(limit).map { $0 } ?? []
    }
}
