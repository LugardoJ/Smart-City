//
//  ToggleFavoriteCityUseCase.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//

protocol ToggleFavoriteCityUseCase {
    func execute(city: City)
    func fetchFavorites() -> [City]
}

/// Use case to toggle the favorite status of a given city.
///
/// Persists the change via a `FavoriteCityRepository` and updates internal caches.
final class DefaultToggleFavCityUseCase: ToggleFavoriteCityUseCase {
    private let favoriteRepository: FavoriteCityRepository

    init(favoriteRepository: FavoriteCityRepository) {
        self.favoriteRepository = favoriteRepository
    }

    func execute(city: City) {
        favoriteRepository.toggleFavorite(city)
    }

    func fetchFavorites() -> [City] {
        favoriteRepository.favorites()
    }
}
