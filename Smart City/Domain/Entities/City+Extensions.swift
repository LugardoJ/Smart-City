//
//  City+Extensions.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import CoreLocation
import MapKit
import SwiftUI

extension City {
    var coordinateDescription: String {
        "lon: \(coord.lon), lat: \(coord.lat)"
    }

    var coordinateMultiLineDescription: String {
        "lon: \(coord.lon)\nlat: \(coord.lat)"
    }

    var countryName: String {
        country.countryName ?? country
    }

    func coordinateMarker() -> Marker<Label<Text, Text>> {
        Marker(name, monogram: Text(country.flagEmoji), coordinate: coordinate.locationCoordinate)
    }
}

extension City.Coordinate {
    var description: String {
        "lon: \(lon), lat: \(lat)"
    }

    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
