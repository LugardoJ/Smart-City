//
//  CityDetailViewModelTests.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class CityDetailViewModelTests: XCTestCase {
    private var viewModel: CityDetailViewModel!
    private var mockUseCase: MockFetchCitySummaryUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchCitySummaryUseCase()
        viewModel = CityDetailViewModel(fetchSummaryUseCase: mockUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }

    func test_loadSummary_successfullyUpdatesSummary() async {
        let city = City.mock(id: 1, name: "Tokyo")

        let expectedSummary = CityWikiSummary(
            title: "Tokyo",
            description: "Capital of Japan",
            extract: "Tokyo is the capital of Japan.",
            timestamp: "",
            thumbnail: .init(
                source: "https://image.url",
                width: 200,
                height: 200
            )
        )
        mockUseCase.result = .success(expectedSummary)

        await viewModel.loadSummary(for: city)

        XCTAssertEqual(viewModel.summary?.title, "Tokyo")
        XCTAssertNil(viewModel.error)
    }

    func test_loadSummary_failsWithError() async {
        let city = City.mock(id: 2, name: "Paris")
        mockUseCase.result = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"]))

        await viewModel.loadSummary(for: city)

        XCTAssertNil(viewModel.summary)
        XCTAssertEqual(viewModel.error, "Network error")
    }

    func test_loadSummary_setsCorrectDescription() async {
        let city = City.mock(id: 3, name: "New York")

        mockUseCase.result = .success(CityWikiSummary(
            title: "New York",
            description: "NYC description",
            extract: "NYC extract.",
            timestamp: "",
            thumbnail: nil
        ))

        await viewModel.loadSummary(for: city)

        XCTAssertEqual(viewModel.summary?.description, "NYC description")
        XCTAssertNil(viewModel.error)
    }

    func test_loadSummary_withoutImage_setsSummaryAndNoError() async {
        let city = City.mock(id: 3, name: "Berlin")

        let summaryWithoutImage = CityWikiSummary(
            title: "Berlin",
            description: "Capital of Germany.",
            extract: "A historical and cultural city.",
            timestamp: "",
            thumbnail: nil
        )
        mockUseCase.result = .success(summaryWithoutImage)

        await viewModel.loadSummary(for: city)

        XCTAssertEqual(viewModel.summary?.title, "Berlin")
        XCTAssertNil(viewModel.summary?.originalimage)
        XCTAssertNil(viewModel.error)
    }
}
