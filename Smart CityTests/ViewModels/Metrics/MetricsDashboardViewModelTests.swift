//
//  MetricsDashboardViewModelTests.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class MetricsDashboardViewModelTests: XCTestCase {
    var viewModel: MetricsDashboardViewModel!

    override func setUp() {
        super.setUp()
        let topTermsUC = DefaultTopSearchTermsUseCase(repo: MockMetricsQueryRepository.withTopTerms())
        let topCitiesUC = DefaultTopVisitedCitiesUseCase(repo: MockMetricsQueryRepository.withTopCities())
        let loadTimesUC = DefaultFetchLoadTimeMetricsUseCase(context: MockModelContext())
        let toggleFavoriteUC = MockToggleFavoriteCityUseCase.withFavorites()
        let latenciesUC = DefaultFetchSearchLatenciesUseCase(repo: MockMetricsQueryRepository.withLatencies())

        viewModel = MetricsDashboardViewModel(
            fetchTopTermsUseCase: topTermsUC,
            fetchTopCitiesUseCase: topCitiesUC,
            fetchLoadTimesUseCase: loadTimesUC,
            cityRepository: InMemoryCityRepository.stubbedWithCities(),
            toggleFavoriteUseCase: toggleFavoriteUC,
            fetchLatenciesUC: latenciesUC
        )
    }

    func test_loadAllMetrics_setsExpectedValues() async {
        await MainActor.run {
            viewModel.loadAllMetrics(limit: 2)
        }

        XCTAssertEqual(viewModel.topSearchTerms.count, 2)
        XCTAssertEqual(viewModel.topVisitedCities.count, 2)
        XCTAssertEqual(viewModel.loadTimes.count, 0)
        XCTAssertEqual(viewModel.favoritesByCountry.first?.country, "Mockland")
        XCTAssertEqual(viewModel.searchLatencies.count, 2)
    }

    func test_topVisitedCities_mapsCorrectlyFromIDs() async {
        await MainActor.run {
            viewModel.loadAllMetrics(limit: 2)
        }

        XCTAssertEqual(viewModel.topVisitedCities.count, 2)
        XCTAssertEqual(viewModel.topVisitedCities.first?.0.name, "City A")
    }
}
