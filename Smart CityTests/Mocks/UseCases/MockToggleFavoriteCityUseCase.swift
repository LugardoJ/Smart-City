//
//  MockToggleFavoriteCityUseCase.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class MockToggleFavoriteCityUseCase: ToggleFavoriteCityUseCase {
    var toggledCities: [City] = []
    var favorites: [City] = []

    func execute(city: City) {
        toggledCities.append(city)
    }

    func fetchFavorites() -> [City] {
        favorites
    }
}
