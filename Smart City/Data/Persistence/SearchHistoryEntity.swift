//
//  SearchHistoryEntity.swift
//  Smart City
//
//  Created by Lugardo on 30/06/25.
//
import SwiftData
import Foundation

@Model
final class SearchHistoryEntity: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var cityId: Int
    var cityName: String
    var country: String
    var searchCount: Int
    var lastSearchedAt: Date

    init(cityId: Int, cityName: String, country: String) {
        self.cityId = cityId
        self.cityName = cityName
        self.country = country
        self.searchCount = 1
        self.lastSearchedAt = Date()
    }

    func updateSearchStats() {
        searchCount += 1
        lastSearchedAt = Date()
    }
}

@Model
final class SearchQueryHistoryEntity {
    @Attribute(.unique) var term: String
    var searchCount: Int
    var lastSearchedAt: Date

    init(term: String) {
        self.term = term
        self.searchCount = 1
        self.lastSearchedAt = Date()
    }

    func updateSearchStats() {
        self.searchCount += 1
        self.lastSearchedAt = Date()
    }
}
