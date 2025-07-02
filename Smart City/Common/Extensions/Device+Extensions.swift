//
//  Device+Extensions.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import SwiftUI

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension UIDevice {
    var supportsSplitView: Bool {
        if userInterfaceIdiom == .pad {
            return true
        } else if userInterfaceIdiom == .phone {
            let size = UIScreen.main.bounds.size
            let maxDimension = max(size.width, size.height)
            return maxDimension >= 896 // iPhone XS Max, 11 Pro Max, 12 Pro Max y superiores
        } else {
            return false
        }
    }
}
