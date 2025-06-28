//
//  CityDetailView.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
import SwiftUI

// MARK: - Views (Presentation Layer)

struct CityDetailView: View {
    let city: City

    var body: some View {
        VStack(spacing: 20) {
            Text(city.name)
                .font(.largeTitle)
            Text("Country: \(city.country)")
            Text("Lat: \(city.coordinate.lat), Lon: \(city.coordinate.lon)")
        }
        .padding()
        .navigationTitle(city.name)
    }
}
