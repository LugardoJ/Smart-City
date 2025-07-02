//
//  VisitMetricEntity.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
import Foundation
import SwiftData

@Model
public final class VisitMetricEntity {
    public var cityId: Int
    public var count: Int
    public var lastVisitedAt: Date

    public init(cityId: Int) {
        self.cityId = cityId
        count = 1
        lastVisitedAt = Date()
    }

    public func record() {
        count += 1
        lastVisitedAt = Date()
    }
}
