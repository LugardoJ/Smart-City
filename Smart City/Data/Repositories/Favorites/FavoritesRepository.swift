//
//  FavoritesRepository.swift
//  Smart City
//
//  Created by Lugardo on 28/06/25.
//
/// Handles the persistent storage and toggling logic for user-selected favorite cities.
protocol FavoriteCityRepository {
    func toggleFavorite(_ city: City)
    func isFavorite(_ city: City) -> Bool
    func favorites() -> [City]
}
