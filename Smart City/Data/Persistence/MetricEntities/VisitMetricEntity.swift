//
//  VisitMetricEntity.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
import SwiftData
import Foundation

@Model
public final class VisitMetricEntity {
    public var cityId: Int
    public var count: Int
    public var lastVisitedAt: Date

    public init(cityId: Int) {
        self.cityId        = cityId
        self.count         = 1
        self.lastVisitedAt = Date()
    }

    public func record() {
        count += 1
        lastVisitedAt = Date()
    }
}
