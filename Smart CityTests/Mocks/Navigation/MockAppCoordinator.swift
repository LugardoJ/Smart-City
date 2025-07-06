//
//  MockAppCoordinator.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class MockAppCoordinator: AppCoordinatorProtocol {
    var navigatedTo: AppRoute?

    func navigate(to route: AppRoute) {
        navigatedTo = route
    }

    func pop() async {}

    func current() async -> AppRoute? {
        nil
    }

    func reset() async {}

    func setCity(_ city: City) async {}
}
