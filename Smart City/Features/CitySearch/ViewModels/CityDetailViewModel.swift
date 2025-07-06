//
//  CityDetailViewModel.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import SwiftUI

public protocol CityDetailViewModelProtocol {
    var summary: CityWikiSummary? { get }
    var error: String? { get }
    func loadSummary(for city: City) async
}

// @MainActor
@Observable
final class CityDetailViewModel: CityDetailViewModelProtocol {
    private let fetchSummaryUseCase: FetchCitySummaryUseCase

    var summary: CityWikiSummary?
    var isLoading = false
    var error: String?

    init(fetchSummaryUseCase: FetchCitySummaryUseCase) {
        self.fetchSummaryUseCase = fetchSummaryUseCase
    }

    func loadSummary(for city: City) async {
        isLoading = true
        do {
            summary = try await fetchSummaryUseCase.execute(for: city.name)
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
