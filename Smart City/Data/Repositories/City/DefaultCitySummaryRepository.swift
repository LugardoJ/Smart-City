//
//  DefaultCitySummaryRepository.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
final class DefaultCitySummaryRepository: CitySummaryRepository {
    private let dataSource: WikipediaRemoteDataSource

    init(dataSource: WikipediaRemoteDataSource = WikipediaRemoteDataSource()) {
        self.dataSource = dataSource
    }

    func fetchSummary(for cityName: String) async throws -> CityWikiSummary {
        try await dataSource.fetchSummary(for: cityName)
    }
}
