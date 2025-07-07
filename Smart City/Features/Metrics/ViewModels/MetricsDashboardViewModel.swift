//
//  MetricsDashboardViewModel.swift
//  Smart City
//
//  Created by Lugardo on 03/07/25.
//
import SwiftUI
/// View model powering the Metrics Dashboard UI.
///
/// It aggregates key metrics for performance and product analytics:
/// - Top searched terms
/// - Most visited cities
/// - Load times and search latencies
///
/// Retrieves data via SwiftData-backed repositories or adapters.
@Observable
final class MetricsDashboardViewModel {
    private let fetchTopTermsUC: FetchTopSearchTermsUseCase
    private let fetchTopCitiesUC: FetchTopVisitedCitiesUseCase
    private let fetchLoadTimesUC: FetchLoadTimeMetricsUseCase
    private let cityRepository: CityRepository
    private let toggleFavoriteUseCase: ToggleFavoriteCityUseCase
    private let fetchLatenciesUC: FetchSearchLatenciesUseCase

    var topSearchTerms: [(String, Int)] = []
    var topVisitedCities: [(City, Int)] = []
    var loadTimes: [LoadTime] = []
    var favoritesByCountry: [(country: String, count: Int)] = []

    var searchLatencies: [SearchLatency] = []

    init(
        fetchTopTermsUseCase: FetchTopSearchTermsUseCase,
        fetchTopCitiesUseCase: FetchTopVisitedCitiesUseCase,
        fetchLoadTimesUseCase: FetchLoadTimeMetricsUseCase,
        cityRepository: CityRepository,
        toggleFavoriteUseCase: ToggleFavoriteCityUseCase,
        fetchLatenciesUC: FetchSearchLatenciesUseCase
    ) {
        fetchTopTermsUC = fetchTopTermsUseCase
        fetchTopCitiesUC = fetchTopCitiesUseCase
        fetchLoadTimesUC = fetchLoadTimesUseCase
        self.cityRepository = cityRepository
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.fetchLatenciesUC = fetchLatenciesUC
    }

    @MainActor func loadAllMetrics(limit: Int = 5) {
        topSearchTerms = fetchTopTermsUC.execute(limit: limit)
        let ids = fetchTopCitiesUC.execute(limit: limit)
        let allCities = cityRepository.getCitites()
        let cityMap = Dictionary(uniqueKeysWithValues: allCities
            .map { ($0.id, $0) })

        topVisitedCities = ids.compactMap { cityId, count in
            guard let city = cityMap[cityId] else { return nil }
            return (city, count)
        }

        loadTimes = fetchLoadTimesUC.execute()
            .sorted(by: { $0.timestamp < $1.timestamp })

        let favs = toggleFavoriteUseCase.fetchFavorites()
        let grouped = Dictionary(grouping: favs, by: \.country)
        favoritesByCountry = grouped
            .map { (country: $0.key, count: $0.value.count) }
            .sorted(by: { $0.country < $1.country })

        searchLatencies = fetchLatenciesUC.execute(limit: 130)
    }
}
