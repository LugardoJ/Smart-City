//
//  SearchMetricEntity.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
import SwiftData
import Foundation

@Model
public final class SearchMetricEntity {
    @Attribute(.unique) public var term: String
    public var count: Int
    public var lastSearchedAt: Date

    public init(term: String) {
        self.term         = term
        self.count         = 1
        self.lastSearchedAt = Date()
    }

    public func record() {
        count += 1
        lastSearchedAt = Date()
    }
}
