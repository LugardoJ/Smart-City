//
//  ToggleFavoriteCityUseCase.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
// MARK: - Use Cases (Domain Layer)

protocol ToggleFavoriteCityUseCase {
    func execute(city: City)
}

// MARK: - Use Case Implementations (Domain Layer)

final class DefaultToggleFavoriteCityUseCase: ToggleFavoriteCityUseCase {
    private let repository: CityRepository
    
    init(repository: CityRepository) {
        self.repository = repository
    }
    
    func execute(city: City) {
        repository.toggleFavorite(city)
    }
}
