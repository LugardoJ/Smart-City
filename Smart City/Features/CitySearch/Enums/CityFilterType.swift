//
//  CityFilterType.swift
//  Smart City
//
//  Created by Lugardo on 30/06/25.
//
enum CityFilterType: CaseIterable, Identifiable {
    case all
    case favorites

    var id: Self { self }

    var title: String {
        switch self {
        case .all: "All"
        case .favorites: "Favorites"
        }
    }
}
