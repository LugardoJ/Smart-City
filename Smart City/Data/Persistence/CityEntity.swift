//
//  CityEntity.swift
//  Smart City
//
//  Created by Lugardo on 28/06/25.
//
import SwiftData

@Model
final class CityEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var country: String
    var lon: Double
    var lat: Double
    var isFavorite: Bool

    init(id: Int, name: String, country: String, lon: Double, lat: Double,isFavorite: Bool) {
        self.id = id
        self.name = name
        self.country = country
        self.lon = lon
        self.lat = lat
        self.isFavorite = isFavorite
    }
    
    var toDomain: City {
        City(id: id, name: name, country: country, coord: .init(lon: lon, lat: lat), isFavorite: isFavorite)
    }
    
    static func fromDomain(_ city: City) -> CityEntity {
        CityEntity(id: city.id,name: city.name,country: city.country,lon: city.coord.lon,lat: city.coord.lat,isFavorite: city.isFavorite)
    }
    
    func update(from model: City) {
        self.name = model.name
        self.country = model.country
        self.lon = model.coord.lon
        self.lat = model.coord.lat
        self.isFavorite = model.isFavorite
    }
}
