//
//  SwiftDataSearchHistoryRepository.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
import SwiftData
import SwiftUI

public final class SwiftDataSearchHistoryRepository: SearchHistoryRepository {
    private let context: ModelContext

    public init(context: ModelContext) {
        self.context = context
    }

    public func registerQuery(term: String) {
        let desc = FetchDescriptor<SearchHistoryEntity>(predicate: #Predicate { $0.term == term })
        if let existing = try? context.fetch(desc).first {
            existing.record()
        } else {
            let newEntry = SearchHistoryEntity(term: term)
            context.insert(newEntry)
        }
        try? context.save()
    }

    public func fetchRecentSearches(limit: Int = 10) -> [SearchHistoryEntity] {
        let desc = FetchDescriptor<SearchHistoryEntity>(
            sortBy: [SortDescriptor(\.lastSearchedAt, order: .reverse)]
        )
        return (try? context.fetch(desc))?.prefix(limit).map { $0 } ?? []
    }

    public func fetchMostSearched(limit: Int = 10) -> [SearchHistoryEntity] {
        let desc = FetchDescriptor<SearchHistoryEntity>(
            sortBy: [SortDescriptor(\.count, order: .reverse)]
        )
        return (try? context.fetch(desc))?.prefix(limit).map { $0 } ?? []
    }

    public func clearHistory() {
        let all = (try? context.fetch(FetchDescriptor<SearchHistoryEntity>())) ?? []
        all.forEach(context.delete)
        try? context.save()
    }

    public func deleteQueries(_ terms: [String]) {
        for term in terms {
            let desc = FetchDescriptor<SearchHistoryEntity>(predicate: #Predicate { $0.term == term })
            if let entity = try? context.fetch(desc).first {
                context.delete(entity)
            }
        }
        try? context.save()
    }
}
