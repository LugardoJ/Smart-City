//
//  ToggleFavoriteCityUseCase.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
// MARK: - Use Cases (Domain Layer)

protocol ToggleFavoriteCityUseCase {
    func execute(city: City)
    func fetchFavorites() -> [City]
}

// MARK: - Use Case Implementations (Domain Layer)

final class DefaultToggleFavoriteCityUseCase: ToggleFavoriteCityUseCase {
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
