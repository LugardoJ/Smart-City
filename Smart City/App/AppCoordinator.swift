//
//  AppCoordinator.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
import SwiftUI

@MainActor
public final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectedCity: City?

    func navigate(to route: AppRoute) {
        switch route {
        case let .cityDetail(city):
            selectedCity = city
            path.append(city)
        }
    }

    func pop() {
        path.removeLast()
        selectedCity = nil
    }

    func reset() {
        path.removeLast(path.count)
        selectedCity = nil
    }
}
