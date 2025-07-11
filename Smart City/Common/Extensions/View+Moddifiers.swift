//
//  View+Moddifiers.swift
//  Smart City
//
//  Created by Lugardo on 28/06/25.
//
import SwiftUI

extension View {
    @ViewBuilder func `if`(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func loadingView(isPresented: Bool) -> some View {
        zIndex(0)
            .overlay {
                if isPresented {
                    Color
                        .secondary.opacity(0.8)
                        .ignoresSafeArea(.all)
                        .zIndex(1)
                    ProgressView()
                        .zIndex(1)
                        .tint(.white)
                        .accessibilityIdentifier("loadingSpinner")
                }
            }
            .animation(.easeInOut(duration: 1.5), value: isPresented)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: radius,
                height: radius
            )
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        modifier(DeviceRotationViewModifier(action: action))
    }
}
