//
//  MockFetchCitySummaryUseCase.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
import Foundation
@testable import Smart_City

final class MockFetchCitySummaryUseCase: FetchCitySummaryUseCase {
    var result: Result<CityWikiSummary, Error>?

    func execute(for cityName: String) async throws -> CityWikiSummary {
        switch result {
        case let .success(summary):
            return summary
        case let .failure(error):
            throw error
        case .none:
            throw NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No result set"])
        }
    }
}
