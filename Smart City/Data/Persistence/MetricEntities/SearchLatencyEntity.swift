//
//  SearchLatencyEntity.swift
//  Smart City
//
//  Created by Lugardo on 03/07/25.
//
import Foundation
import SwiftData

@Model
public final class SearchLatencyEntity {
    @Attribute(.unique) public var id = UUID()
    public var query: String
    public var duration: Double
    public var timestamp: Date

    public init(query: String, duration: TimeInterval) {
        self.query = query
        self.duration = duration
        timestamp = .now
    }
}
