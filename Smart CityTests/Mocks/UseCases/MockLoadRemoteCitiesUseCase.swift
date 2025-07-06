//
//  MockLoadRemoteCitiesUseCase.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class MockLoadRemoteCitiesUseCase: LoadRemoteCitiesUseCase {
    var executed = false
    func execute() async throws -> [City] {
        executed = true
        return [City.mock(name: "Loaded Remote")]
    }

    func execute() async throws {
        executed = true
    }
}
