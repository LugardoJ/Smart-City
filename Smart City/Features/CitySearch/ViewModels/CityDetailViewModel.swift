//
//  CityDetailViewModel.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import SwiftUI

@MainActor
@Observable
final class CityDetailViewModel {
    var summary: CityWikiSummary?
    var isLoading = false
    var error: String?

    private let fetchSummaryUseCase: FetchCitySummaryUseCase

    init(fetchSummaryUseCase: FetchCitySummaryUseCase) {
        self.fetchSummaryUseCase = fetchSummaryUseCase
    }

    func loadSummary(for city: City) async {
        isLoading = true
        do {
            summary = try await fetchSummaryUseCase.execute(for: city.name)
            error = nil
        } catch {
            self.error = "Failed to load summary"
        }
        isLoading = false
    }
}
