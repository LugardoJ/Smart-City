//
//  CityFilterType.swift
//  Smart City
//
//  Created by Lugardo on 30/06/25.
//
/// Enum representing filters applied to the city list (e.g. favorites only).
///
/// Used to update the visible results without affecting the full dataset.
public enum CityFilterType: CaseIterable, Identifiable {
    case all
    case favorites

    public var id: Self { self }

    public var title: String {
        switch self {
        case .all: "All"
        case .favorites: "Favorites"
        }
    }

    public var symbolIcon: String {
        switch self {
        case .all:
            "list.bullet"
        case .favorites:
            "list.star"
        }
    }
}
