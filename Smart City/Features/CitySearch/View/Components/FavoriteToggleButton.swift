//
//  FavoriteToggleButton.swift
//  Smart City
//
//  Created by Lugardo on 07/07/25.
//
import SwiftUI

/// Toolbar button that toggles the city's favorite state with animation and feedback.
public struct FavoriteToggleButton: View {
    @Binding var city: City

    public var body: some View {
        Button {
            withAnimation {
                city.isFavorite.toggle()
            }
        } label: {
            Image(systemName: city.isFavorite ? "heart.fill" : "heart")
                .contentTransition(.symbolEffect(.replace))
        }
        .tint(city.isFavorite ? .red : .accentColor)
        .sensoryFeedback(.success, trigger: city.isFavorite)
        .accessibilityIdentifier("favoriteButton_\(city.id)")
    }
}
