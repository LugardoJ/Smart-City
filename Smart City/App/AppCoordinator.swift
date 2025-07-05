//
//  AppCoordinator.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
import SwiftUI

@MainActor
public final class AppCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []
    @Published var selectedCity: City?

    func navigate(to route: AppRoute) {
        switch route {
        case .cityDetail:
            path = [route]
        case .metricsDashboard:
            selectedCity = nil
            path = [route]
        }
    }

    func pop() {
        path.removeLast()
        selectedCity = nil
    }

    func current() -> AppRoute? {
        path.last
    }

    func reset() {
        path.removeLast(path.count)
        selectedCity = nil
    }

    func setCity(_ city: City) {
        selectedCity = city
    }
}
