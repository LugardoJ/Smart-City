//
//  FloatingFavoritesButtonModifier.swift
//  Smart City
//
//  Created by Lugardo on 07/07/25.
//
import SwiftUI

/// ViewModifier that adds a floating circular button to toggle between
/// all cities and favorite cities.
struct FloatingFavoritesButtonModifier: ViewModifier {
    @Binding var selectedFilter: CityFilterType

    func body(content: Content) -> some View {
        content.overlay(alignment: .bottomTrailing) {
            Button {
                withAnimation {
                    selectedFilter = selectedFilter == .favorites ? .all : .favorites
                }
            } label: {
                Image(systemName: selectedFilter == .favorites ? "heart.fill" : "heart")
                    .font(.title2)
                    .aspectRatio(contentMode: .fit)
                    .padding(5)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(selectedFilter == .favorites ? .red : .secondary, .white)
                    .background(.white)
                    .clipShape(.circle)
                    .shadow(radius: 3)
                    .padding(.trailing, 5)
            }
            .padding()
            .contentTransition(.symbolEffect(.replace))
            .accessibilityIdentifier("floatingFavoritesButton")
        }
    }
}
