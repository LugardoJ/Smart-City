//
//  AppCoordinator.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
import SwiftUI

/// Manages high-level navigation across feature flows.
/// 
/// `AppCoordinator` is injected into view models and views to control push, pop,
/// sheet presentation, and deep-linking logic. It abstracts routing across compact
/// and split view environments.
public protocol AppCoordinatorProtocol: AnyObject {
    func navigate(to route: AppRoute) async
    func pop() async
    func current() async -> AppRoute?
    func reset() async
    func setCity(_ city: City) async
}

@MainActor
public final class AppCoordinator: ObservableObject, AppCoordinatorProtocol {
    @Published var path: [AppRoute] = []
    @Published var selectedCity: City?

    public func navigate(to route: AppRoute) {
        switch route {
        case .cityDetail:
            path = [route]
        case .metricsDashboard:
            selectedCity = nil
            path = [route]
        }
    }

    public func pop() {
        path.removeLast()
        selectedCity = nil
    }

    public func current() -> AppRoute? {
        path.last
    }

    public func reset() {
        path.removeLast(path.count)
        selectedCity = nil
    }

    public func setCity(_ city: City) {
        selectedCity = city
    }
}
