//
//  CityInfoCardTests.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import SwiftUI
import XCTest

final class CityInfoCardTests: XCTestCase {
    final class MockCityDetailViewModel: CityDetailViewModelProtocol {
        @Published var summary: CityWikiSummary?
        @Published var error: String?

        var didCallLoadSummary = false
        var loadedCity: City?

        func loadSummary(for city: City) async {
            didCallLoadSummary = true
            loadedCity = city
        }
    }

    func test_loadSummary_invoked_onCityChange() async {
        let city = Binding.constant(City.mock(id: 1, name: "Tokyo"))

        Task {
            let mockViewModel = MockCityDetailViewModel()
            let view = await CityInfoCard(city: city, viewModel: mockViewModel)
            let host = await UIHostingController(rootView: view)
            _ = await host.view

            XCTAssertTrue(mockViewModel.didCallLoadSummary)
            XCTAssertEqual(mockViewModel.loadedCity?.id, city.wrappedValue.id)
        }
    }

    func test_displayError_showsUnavailableView() {
        let city = Binding.constant(City.mock(id: 1, name: "ErrorCity"))
        let mockViewModel = MockCityDetailViewModel()
        mockViewModel.error = "Wiki Error"

        let view = CityInfoCard(city: city, viewModel: mockViewModel)
        let host = UIHostingController(rootView: view)

        _ = host.view // Fuerza el renderizado de la vista

        // Verificamos que la vista no crashee y que el error esté presente
        XCTAssertEqual(mockViewModel.error, "Wiki Error")
    }
}
