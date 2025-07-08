//
//  InfoButton.swift
//  Smart City
//
//  Created by Lugardo on 07/07/25.
//
import SwiftUI

/// Toolbar button that toggles the presentation of city information card.
public struct InfoButton: View {
    @Binding var presentInfo: Bool

    public var body: some View {
        Button {
            withAnimation(.bouncy) {
                presentInfo.toggle()
            }
        } label: {
            Image(systemName: "info.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.white, .blue)
        }
        .accessibilityIdentifier("infoButton")
    }
}
