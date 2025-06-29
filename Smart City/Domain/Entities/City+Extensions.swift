//
//  City+Extensions.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
extension City {
    var coordinateDescription: String {
        "lon: \(coord.lon), lat: \(coord.lat)"
    }
    
    var countryName : String{
        self.country.countryName ?? self.country
    }
}

extension City.Coordinate {
    var description: String {
        "lon: \(lon), lat: \(lat)"
    }
}
