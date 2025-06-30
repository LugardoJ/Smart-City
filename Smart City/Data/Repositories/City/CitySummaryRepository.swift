//
//  CitySummaryRepository.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//

protocol CitySummaryRepository {
    func fetchSummary(for cityName: String) async throws -> CityWikiSummary
}
