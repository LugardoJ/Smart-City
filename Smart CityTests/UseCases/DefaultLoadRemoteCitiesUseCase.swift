//
//  DefaultLoadRemoteCitiesUseCase.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class LoadRemoteCitiesUseCaseTests: XCTestCase {
    func testExecuteReturnsLoadedCities() async throws {
        let repository = MockCityRepository()
        let useCase = DefaultLoadRemoteCitiesUseCase(repository: repository)
        try await useCase.execute()
        let result = repository.getCitites()

        XCTAssertTrue(repository.loadCitiesCalled)
        XCTAssertTrue(repository.getCitiesCalled)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.name, "London")
    }
}
