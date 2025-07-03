//
//  SearchRowView.swift
//  Smart City
//
//  Created by Lugardo on 28/06/25.
//
import SwiftUI

struct SearchRowView: View {
    @Binding var city: City

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(city.country.flagEmoji)
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text(city.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(city.countryName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
            Spacer()

            Image(systemName: city.isFavorite ? "heart.fill" : "heart")
                .imageScale(.small)
                .foregroundStyle(city.isFavorite ? .red : .secondary)
                .contentTransition(.symbolEffect(.replace))
        }
    }
}

#Preview {
    @Previewable @State var isFavorite = false
    SearchRowView(city:
        .constant(.init(
            id: 0,
            name: "Tokyo",
            country: "JP",
            coord: .init(lon: 100.320, lat: 100.203),
            isFavorite: isFavorite
        )
        ))
}
