//
//  SwiftDataMetricsQueryRepositoryTests.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class SwiftDataMetricsQueryRepositoryTests: XCTestCase {
    var swfitDataMetrics: SwiftDataMetricsQueryRepository!

    override func setUpWithError() throws {
        let mockContext = MockModelContext()
        swfitDataMetrics = SwiftDataMetricsQueryRepository(context: mockContext)
    }

    func test_fetchTopSearchTerms_returnsLimitedResults() {
        let terms = swfitDataMetrics.fetchTopSearchTerms(limit: 5)
        XCTAssertNotNil(terms)
        XCTAssertTrue(terms.isEmpty)
    }

    func test_fetchSearchLatencies_returnsEmptyIfNone() {
        let result = swfitDataMetrics.fetchSearchLatencies(limit: 10)
        XCTAssertEqual(result.count, 0)
    }

    func test_fetchTopVisitedCities_returnsEmptyIfNone() {
        let result = swfitDataMetrics.fetchTopVisitedCities(limit: 3)
        XCTAssertTrue(result.isEmpty)
    }
}
