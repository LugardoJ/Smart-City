//
//  MockCityRepository.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//

final class MockCityRepository: CityRepository {
    var loadCitiesCalled = false
    var cities: [City] = [City.mock(name: "London"), City.mock(name: "Paris")]
    var getCitiesCalled = false

    func loadCitiesRemote() async throws {
        loadCitiesCalled = true
    }

    func getCitites() -> [City] {
        getCitiesCalled = true
        return cities
    }

    func searchCities(matching query: String) -> [City] {
        []
    }

    func setCities(_ cities: [City]) {
        self.cities = cities
    }
}
