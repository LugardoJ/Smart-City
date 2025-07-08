//
//  CityRowButton.swift
//  Smart City
//
//  Created by Lugardo on 07/07/25.
//
import SwiftUI

/// A reusable row used to display a single city within a list.
/// Supports selection, swipe-to-favorite, and appearance animations.
struct CityRowButton: View {
    let city: Binding<City>
    let isSelected: Bool
    let onTap: () -> Void
    let onSwipe: () -> Void
    let onAppear: () -> Void

    var body: some View {
        Button(action: onTap) {
            SearchRowView(city: city, selected: .constant(isSelected))
        }
        .contentShape(Rectangle())
        .onAppear(perform: onAppear)
        .swipeActions(edge: .trailing) {
            Button(action: onSwipe) {
                Image(systemName: city.wrappedValue.isFavorite ? "heart.slash" : "heart.fill")
            }
            .tint(.red)
            .sensoryFeedback(.success, trigger: city.wrappedValue.isFavorite)
            .accessibilityIdentifier("favoriteSwipeButton_\(city.wrappedValue.id)")
        }
        .foregroundStyle(.primary)
        .accessibilityIdentifier("cityRow_\(city.wrappedValue.id)")
    }
}
