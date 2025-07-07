//
//  DefaultCitySummaryRepository.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
/// Default implementation of `CitySummaryRepository` using Wikipedia’s API.
///
/// This repository performs live HTTP requests and does **not** cache responses.
/// Summary data is parsed into a `CityWikiSummary` value type.
final class DefaultCitySummaryRepository: CitySummaryRepository {
    private let dataSource: WikipediaDataSourceProtocol

    init(dataSource: WikipediaDataSourceProtocol = WikipediaRemoteDataSource()) {
        self.dataSource = dataSource
    }

    func fetchSummary(for cityName: String) async throws -> CityWikiSummary {
        try await dataSource.fetchSummary(for: cityName)
    }
}
