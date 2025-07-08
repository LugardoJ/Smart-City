//
//  RecentSearchRow.swift
//  Smart City
//
//  Created by Lugardo on 07/07/25.
//
import SwiftUI

/// Displays a recent query term with an icon and tap interaction.
/// Part of the recent search section in CitySearchView.
struct RecentSearchRow: View {
    let query: String
    let onTap: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "clock")
                .imageScale(.small)
                .foregroundStyle(.secondary)
            Text(query)
                .font(.body)
                .foregroundStyle(.secondary)
            Spacer()
            Image(systemName: "arrow.up.left")
                .foregroundStyle(.secondary)
                .opacity(0.5)
        }
        .contentShape(Capsule())
        .onTapGesture(perform: onTap)
    }
}
