//
//  EmptySearchOverlayModifier.swift
//  Smart City
//
//  Created by Lugardo on 07/07/25.
//
import SwiftUI

/// ViewModifier that overlays a `ContentUnavailableView` when a search yields no results
/// and loading has finished.
struct EmptySearchOverlayModifier: ViewModifier {
    let isLoading: Bool
    let message: String?

    func body(content: Content) -> some View {
        content.if(!isLoading, transform: { view in
            view.overlay(alignment: .center) {
                if let message = message {
                    ContentUnavailableView("Search", systemImage: "magnifyingglass", description: Text(message))
                        .transition(.opacity)
                        .animation(.easeInOut, value: message)
                }
            }
            .accessibilityIdentifier("emptySearchView")
        })
    }
}
