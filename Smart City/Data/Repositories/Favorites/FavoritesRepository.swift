//
//  FavoritesRepository.swift
//  Smart City
//
//  Created by Lugardo on 28/06/25.
//
protocol FavoriteCityRepository {
    func toggleFavorite(_ city: City)
    func isFavorite(_ city: City) -> Bool
    func favorites() -> [City]
}
