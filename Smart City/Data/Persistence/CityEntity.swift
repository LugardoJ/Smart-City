//
//  CityEntity.swift
//  Smart City
//
//  Created by Lugardo on 28/06/25.
//
import SwiftData

/// A SwiftData model representing a city with favorite status.
///
/// Used to persist user interactions such as marking favorites or search history.
@Model
final class CityEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var country: String
    var lon: Double
    var lat: Double
    var isFavorite: Bool

    init(id: Int, name: String, country: String, lon: Double, lat: Double, isFavorite: Bool) {
        self.id = id
        self.name = name
        self.country = country
        self.lon = lon
        self.lat = lat
        self.isFavorite = isFavorite
    }

    var toDomain: City {
        City(
            id: id,
            name: name,
            country: country,
            coord: .init(lon: lon, lat: lat),
            isFavorite: isFavorite
        )
    }

    static func fromDomain(_ city: City) -> CityEntity {
        CityEntity(
            id: city.id,
            name: city.name,
            country: city.country,
            lon: city.coord.lon,
            lat: city.coord.lat,
            isFavorite: city.isFavorite
        )
    }

    func update(from model: City) {
        name = model.name
        country = model.country
        lon = model.coord.lon
        lat = model.coord.lat
        isFavorite = model.isFavorite
    }
}
