//
//  SwiftDataFavoritesRepository.swift
//  Smart City
//
//  Created by Lugardo on 28/06/25.
//
import SwiftData
import SwiftUI

final class SwiftDataFavoritesRepository: FavoriteCityRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func favorites() -> [City] {
        let descriptor = FetchDescriptor<CityEntity>(predicate: #Predicate { $0.isFavorite })
        let entities = (try? context.fetch(descriptor)) ?? []
        return entities.map(\.toDomain)
    }

    func toggleFavorite(_ city: City) {
        let descriptor = FetchDescriptor<CityEntity>(predicate: #Predicate { $0.id == city.id })
        guard let entity = try? context.fetch(descriptor).first else { return }
        entity.isFavorite.toggle()
        try? context.save()
    }

    func isFavorite(_ city: City) -> Bool {
        let descriptor = FetchDescriptor<CityEntity>(predicate: #Predicate { $0.id == city.id })
        return (try? context.fetch(descriptor).first?.isFavorite) ?? false
    }

    func fetchFavoriteIDs() -> Set<Int> {
        Set(favorites().map(\.id))
    }

    func fetchFavorites(from cities: [City]) -> [City] {
        let ids = fetchFavoriteIDs()
        return cities.filter { ids.contains($0.id) }
    }
}
