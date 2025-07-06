//
//  MetricsUseCasesTests.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class MetricsUseCasesTests: XCTestCase {
    func test_topSearchTerms_returnsLimitedResults() {
        let mockRepo = MockMetricsQueryRepository()
        mockRepo.topSearchTerms = [
            ("paris", 10),
            ("london", 8),
            ("tokyo", 6),
        ]
        let useCase = DefaultTopSearchTermsUseCase(repo: mockRepo)

        let result = useCase.execute(limit: 2)

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].0, "paris")
        XCTAssertEqual(result[1].0, "london")
    }

    func test_topSearchTerms_withEmptyRepo_returnsEmpty() {
        let repo = MockMetricsQueryRepository()
        repo.topSearchTerms = []
        let useCase = DefaultTopSearchTermsUseCase(repo: repo)
        let result = useCase.execute(limit: 5)
        XCTAssertTrue(result.isEmpty)
    }

    func test_fetchTopVisitedCities_returnsCorrectCities() {
        let mockRepo = MockMetricsQueryRepository()
        mockRepo.topVisitedCities = [(1, 5), (2, 3), (3, 1)]
        let useCase = DefaultTopVisitedCitiesUseCase(repo: mockRepo)

        let result = useCase.execute(limit: 2)

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].0, 1)
        XCTAssertEqual(result[1].0, 2)
    }

    func test_fetchSearchLatencies_returnsLatestLatencies() {
        let mockRepo = MockMetricsQueryRepository()
        mockRepo.latencies = [
            SearchLatency(query: "a", duration: 0.3, timestamp: Date(timeIntervalSinceNow: -10)),
            SearchLatency(query: "b", duration: 0.2, timestamp: Date()),
        ]
        let useCase = DefaultFetchSearchLatenciesUseCase(repo: mockRepo)

        let result = useCase.execute(limit: 1)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.query, "a")
    }

    func test_fetchLoadTimeMetrics_returnsFromMockedContext() {
        let mockContext = MockModelContext()
        let useCase = DefaultFetchLoadTimeMetricsUseCase(context: mockContext)

        let result = useCase.execute()

        XCTAssertEqual(result, [])
    }
}
