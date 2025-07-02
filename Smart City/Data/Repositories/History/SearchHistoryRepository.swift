//
//  SearchHistoryRepository.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
public protocol SearchHistoryRepository {
    func registerQuery(term: String)
    func fetchRecentSearches(limit: Int) -> [SearchHistoryEntity]
    func fetchMostSearched(limit: Int) -> [SearchHistoryEntity]
    func clearHistory()
    
    func deleteQueries(_ terms: [String])
}
