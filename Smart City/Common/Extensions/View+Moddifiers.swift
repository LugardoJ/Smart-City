//
//  View+Moddifiers.swift
//  Smart City
//
//  Created by Lugardo on 28/06/25.
//
import SwiftUI

extension View{
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        }else{
            self
        }
    }
    
    func LoadingView(isPresented: Bool) -> some View {
        ZStack {
            self
                .zIndex(0)
            if isPresented{
                Color.secondary.opacity(0.3).ignoresSafeArea(.all)

                ProgressView()
                    .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 1.5), value: isPresented)
    }
}
