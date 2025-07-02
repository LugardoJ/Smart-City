//
//  SearchHistoryEntity.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
import Foundation
import SwiftData

@Model
public final class SearchHistoryEntity {
    @Attribute(.unique) public var term: String
    public var count: Int
    public var lastSearchedAt: Date

    public init(term: String) {
        self.term = term
        count = 1
        lastSearchedAt = Date()
    }

    public func record() {
        count += 1
        lastSearchedAt = Date()
    }
}
