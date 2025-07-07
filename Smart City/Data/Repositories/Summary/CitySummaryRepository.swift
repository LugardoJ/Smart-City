//
//  CitySummaryRepository.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
/// Abstraction for retrieving Wikipedia summary data for a selected city.
///
/// This repository provides a clean interface for external summary APIs.
protocol CitySummaryRepository {
    func fetchSummary(for cityName: String) async throws -> CityWikiSummary
}
