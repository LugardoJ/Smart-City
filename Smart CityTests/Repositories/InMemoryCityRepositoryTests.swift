//
//  InMemoryCityRepositoryTests.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class InMemoryCityRepositoryTests: XCTestCase {
    func test_setCities_shouldIndexCitiesByFirstLetter() {
        let repo = InMemoryCityRepository()
        let cities = [
            City.mock(id: 1, name: "Amsterdam"),
            City.mock(id: 2, name: "Berlin"),
            City.mock(id: 3, name: "Athens"),
        ]

        repo.setCities(cities)
        let result = repo.getCitites()

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(repo.fetchIndex()["a"]?.count, 2)
        XCTAssertEqual(repo.fetchIndex()["b"]?.count, 1)
    }

    func test_mergeFavorites_shouldUpdateIsFavorite() {
        let repo = InMemoryCityRepository()
        let cities = [
            City.mock(id: 1, name: "London", isFavorite: false),
            City.mock(id: 2, name: "Paris", isFavorite: false),
        ]

        repo.setCities(cities)
        let favs = [
            City.mock(id: 2, name: "Paris", isFavorite: true),
        ]

        repo.mergeFavorites(from: favs)
        let updated = repo.getCitites()
        let paris = updated.first { $0.id == 2 }

        XCTAssertTrue(paris?.isFavorite == true)
    }
}
