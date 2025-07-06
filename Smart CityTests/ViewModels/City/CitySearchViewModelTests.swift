//
//  CitySearchViewModelTests.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//

// MARK: - Mocks para ViewModel de pruebas unitarias

@testable import Smart_City
import XCTest

final class CitySearchViewModelTests: XCTestCase {
    private var viewModel: CitySearchViewModel!
    // Mocks
    private var mockSearchUC: MockSearchCitiesUseCase!
    private var mockLoadUC: MockLoadRemoteCitiesUseCase!
    private var mockToggleFavoriteUC: MockToggleFavoriteCityUseCase!
    private var mockRepo: InMemoryCityRepository!
    private var mockHistoryRepo: MockSearchHistoryRepository!
    private var mockFetchRecentsUC: MockFetchRecentSearchesUseCase!
    private var mockRecordLoadTimeUC: MockRecordLoadTimeUseCase!
    private var mockRecordSearchTermUC: MockRecordSearchTermUseCase!
    private var mockRecordVisitUC: MockRecordCityVisitUseCase!
    private var mockRecordLatencyUC: MockRecordSearchLatencyUseCase!
    private var mockCoordinator: MockAppCoordinator!
    private var mockContext: MockModelContext!

    override func setUp() {
        super.setUp()
        mockSearchUC = .init()
        mockLoadUC = .init()
        mockToggleFavoriteUC = .init()
        mockRepo = InMemoryCityRepository(remoteDataSource: DummyCityRemoteDataSource())
        mockHistoryRepo = .init()
        mockFetchRecentsUC = .init()
        mockRecordLoadTimeUC = .init()
        mockRecordSearchTermUC = .init()
        mockRecordVisitUC = .init()
        mockRecordLatencyUC = .init()
        mockCoordinator = .init()
        mockContext = .init()

        viewModel = CitySearchViewModel(
            searchUseCase: mockSearchUC,
            loadUseCase: mockLoadUC,
            toggleFavoriteUseCase: mockToggleFavoriteUC,
            inMemoryRepository: mockRepo,
            searchHistoryRepository: mockHistoryRepo,
            fetchRecentSearchesUseCase: mockFetchRecentsUC,
            recordLoadTimeUseCase: mockRecordLoadTimeUC,
            recordSearchTermUseCase: mockRecordSearchTermUC,
            recordCityVisitUseCase: mockRecordVisitUC,
            recordSearchLatencyUC: mockRecordLatencyUC,
            coordinator: mockCoordinator,
            context: mockContext
        )
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func test_loadCities_recordsLoadTimeFromNetwork() async {
        await viewModel.loadCities(true)

        XCTAssertEqual(mockRecordLoadTimeUC.recordedCalls.count, 1)
        XCTAssertEqual(mockRecordLoadTimeUC.recordedCalls.first?.source, "network")
    }

    func test_recordCurrentQueryIfNeeded_savesValidTerm() {
        viewModel.query = "paris"
        viewModel.recordCurrentQueryIfNeeded()
        XCTAssertEqual(mockHistoryRepo.registeredTerms, ["paris"])
    }

    func test_recordCurrentQueryIfNeeded_ignoresShortTerm() {
        viewModel.query = "m"
        viewModel.recordCurrentQueryIfNeeded()
        XCTAssertTrue(mockHistoryRepo.registeredTerms.isEmpty)
    }

    func test_loadRecentQueries_setsRecentQueries() {
        let expectation = expectation(description: "Recent queries loaded")

        Task {
            await viewModel.loadRecentQueries()
            XCTAssertEqual(viewModel.recentQueries, ["london", "paris"])
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func test_saveRecentQuery_registersAndStoresIfNotExist() {
        viewModel.saveRecentQuery("tokyo")
        XCTAssertEqual(mockRecordSearchTermUC.terms, ["tokyo"])
        XCTAssertTrue(viewModel.recentQueries.contains("tokyo"))
    }

    func test_clearRecents_deletesFromRepoAndMemory() {
        viewModel.recentQueries = ["london", "paris"]
        viewModel.clearRecents()
        XCTAssertTrue(mockFetchRecentsUC.deletedTerms.contains("london"))
        XCTAssertTrue(viewModel.recentQueries.isEmpty)
    }

    func test_updateGroupedFavorites_groupsAndSortsCorrectly() {
        let cities = [
            City.mock(name: "Zurich", country: "Switzerland"),
            City.mock(name: "Bern", country: "Switzerland"),
            City.mock(name: "Berlin", country: "Germany"),
        ]
        viewModel.favorites = cities
        viewModel.updateGroupedFavorites()
        XCTAssertEqual(viewModel.groupedFavorites.first?.key, "Germany")
        XCTAssertEqual(viewModel.groupedFavorites.first?.value.first?.name, "Berlin")
    }

    func test_toggleFavorite_updatesInternalCollections() {
        let city = City.mock(id: 1, name: "Lima")
        viewModel.results = [city]
        viewModel.toggleFavorite(item: city)
        XCTAssertTrue(mockToggleFavoriteUC.toggledCities.contains(where: { $0.id == city.id }))
        XCTAssertTrue(viewModel.results.first?.isFavorite == true)
        XCTAssertTrue(viewModel.fullFavorites.contains(where: { $0.id == city.id }))
    }

    func test_saveSelect_callsRecordCityVisit() {
        let city = City.mock(id: 55)
        viewModel.saveSelect(city: city)
        XCTAssertEqual(mockRecordVisitUC.visitedIds, [55])
    }
}
