//
//  FetchCitySummaryUseCaseTests.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class FetchCitySummaryUseCaseTests: XCTestCase {
    final class MockCitySummaryRepository: CitySummaryRepository {
        var summaryToReturn: CityWikiSummary?
        var errorToThrow: Error?

        func fetchSummary(for cityName: String) async throws -> CityWikiSummary {
            if let error = errorToThrow {
                throw error
            }

            return summaryToReturn ?? .init(title: cityName, description: "Mock description", extract: "Mock extract", timestamp: "", thumbnail: nil)
        }
    }

    func test_fetchSummary_successful() async throws {
        // Given
        let repository = MockCitySummaryRepository()
        repository.summaryToReturn = CityWikiSummary(title: "Paris", description: "A nice city", extract: "Capital of France", timestamp: "", thumbnail: nil)
        let useCase = DefaultFetchCitySummaryUseCase(repository: repository)
        let city = City.mock(id: 1, name: "Paris")

        // When
        let result = try await useCase.execute(for: city.name)

        // Then
        XCTAssertEqual(result.title, "Paris")
        XCTAssertEqual(result.extract, "Capital of France")
    }

    func test_fetchSummary_throwsError() async {
        // Given
        let repository = MockCitySummaryRepository()
        repository.errorToThrow = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        let useCase = DefaultFetchCitySummaryUseCase(repository: repository)
        let city = City.mock(id: 2, name: "Tokyo")

        // When
        do {
            _ = try await useCase.execute(for: city.name)
            XCTFail("Expected error to be thrown")
        } catch {
            // Then
            XCTAssertEqual(error.localizedDescription, "Network error")
        }
    }
}
