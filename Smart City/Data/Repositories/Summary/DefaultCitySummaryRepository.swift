//
//  DefaultCitySummaryRepository.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
final class DefaultCitySummaryRepository: CitySummaryRepository {
    private let dataSource: WikipediaDataSourceProtocol

    init(dataSource: WikipediaDataSourceProtocol = WikipediaRemoteDataSource()) {
        self.dataSource = dataSource
    }

    func fetchSummary(for cityName: String) async throws -> CityWikiSummary {
        try await dataSource.fetchSummary(for: cityName)
    }
}
