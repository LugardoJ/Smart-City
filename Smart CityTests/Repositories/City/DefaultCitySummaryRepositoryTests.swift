//
//  DefaultCitySummaryRepositoryTests.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class DefaultCitySummaryRepositoryTests: XCTestCase {
    // MARK: - Mock WikipediaRemoteDataSource

    final class MockWikipediaRemoteDataSource: WikipediaDataSourceProtocol {
        var result: Result<CityWikiSummary, Error> = .success(
            CityWikiSummary(
                title: "London",
                description: "Capital of the UK",
                extract: "London is the capital and largest city of England.",
                timestamp: "",
                thumbnail: .init(source: "https://example.com/image.jpg", width: 200, height: 200)
            )
        )

        func fetchSummary(for cityName: String) async throws -> CityWikiSummary {
            switch result {
            case let .success(summary):
                return summary
            case let .failure(error):
                throw error
            }
        }
    }

    private var repository: DefaultCitySummaryRepository!
    private var mockDataSource: MockWikipediaRemoteDataSource!

    override func setUp() {
        super.setUp()
        mockDataSource = MockWikipediaRemoteDataSource()
        repository = DefaultCitySummaryRepository(dataSource: mockDataSource)
    }

    func test_fetchCitySummary_success() async throws {
        let city = City.mock(id: 1, name: "London")

        let result = try await repository.fetchSummary(for: city.name)

        XCTAssertEqual(result.title, "London")
        XCTAssertEqual(result.description, "Capital of the UK")
        XCTAssertEqual(result.extract, "London is the capital and largest city of England.")
        XCTAssertEqual(result.originalimage?.source, "https://example.com/image.jpg")
    }

    func test_fetchCitySummary_failure() async {
        let city = City.mock(id: 2, name: "Paris")
        mockDataSource.result = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch"]))

        do {
            _ = try await repository.fetchSummary(for: city.name)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual((error as NSError).localizedDescription, "Failed to fetch")
        }
    }
}
