//
//  FetchCitySummaryUseCase.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
protocol FetchCitySummaryUseCase {
    func execute(for cityName: String) async throws -> CityWikiSummary
}

final class DefaultFetchCitySummaryUseCase: FetchCitySummaryUseCase {
    private let repository: CitySummaryRepository

    init(repository: CitySummaryRepository) {
        self.repository = repository
    }

    func execute(for cityName: String) async throws -> CityWikiSummary {
        try await repository.fetchSummary(for: cityName)
    }
}
