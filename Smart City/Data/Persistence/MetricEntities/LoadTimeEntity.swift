//
//  LoadTimeEntity.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
import Foundation
import SwiftData

@Model
public final class LoadTimeMetricEntity {
    @Attribute(.unique) public var id = UUID()
    public var source: String
    public var duration: Double
    public var timestamp: Date

    public init(source: String, duration: Double, timestamp: Date = Date()) {
        self.source = source
        self.duration = duration
        self.timestamp = timestamp
    }
}
