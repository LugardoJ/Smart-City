//
//  AppRoute.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//

/// Enum defining all navigation routes within the Smart City feature.
///
/// Used by `AppCoordinator` to identify and trigger screen transitions.
public enum AppRoute: Codable, Hashable {
    case cityDetail
    case metricsDashboard
}
