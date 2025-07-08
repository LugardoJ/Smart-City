//
//  SearchFlowUITests.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
import XCTest

final class SearchFlowUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func test_search_showsExpectedResult() throws {
        XCUIDevice.shared.orientation = .portrait
        let searchField = app.searchFields["Search for cities"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 2), "Search bar not found")

        searchField.tap()
        searchField.typeText("London")

        let cityRow = app.buttons["cityRow_6058560"]
        XCTAssertTrue(cityRow.waitForExistence(timeout: 3), "Expected city not found in results")
    }

    func test_toggleFavoriteLocalhResult() throws {
        XCUIDevice.shared.orientation = .portrait

        let favoriteButton = app.buttons["floatingFavoritesButton"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 2), "Favorite swipe button not found")
        favoriteButton.tap()

        let searchField = app.searchFields["Search for cities"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Search bar not found")

        searchField.tap()
        searchField.typeText("London")

        favoriteButton.tap()
    }

    func test_toggleFavoriteFromSearchResult() throws {
        XCUIDevice.shared.orientation = .portrait

        let searchField = app.searchFields["Search for cities"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Search bar not found")

        searchField.tap()
        searchField.typeText("London")

        let cityRow = app.buttons["cityRow_6058560"]
        XCTAssertTrue(cityRow.waitForExistence(timeout: 5), "City row not found")

        cityRow.swipeLeft()

        let favoriteButton = app.buttons["favoriteSwipeButton_6058560"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 2), "Favorite swipe button not found")

        favoriteButton.tap()
    }

    func test_favoritesScope_onlyShowsFavorites() throws {
        XCUIDevice.shared.orientation = .portrait

        let searchField = app.searchFields["Search for cities"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Search bar not found")

        searchField.tap()
        searchField.typeText("London")

        let cityRow = app.buttons["cityRow_6058560"]
        XCTAssertTrue(cityRow.waitForExistence(timeout: 3), "City row not found")

        let favoriteIcon = app.images["favoriteOn"]
        let isAlreadyFavorite = favoriteIcon.exists
        if !isAlreadyFavorite {
            cityRow.swipeLeft()
            let favoriteButton = app.buttons["favoriteSwipeButton_6058560"]
            if favoriteButton.exists {
                favoriteButton.tap()
            }
        }

        let favoritesScope = app.segmentedControls.buttons["Favorites"]
        XCTAssertTrue(favoritesScope.waitForExistence(timeout: 3), "Favorites scope not found")
        favoritesScope.tap()

        let favoriteRow = app.buttons["cityRow_6058560"]
        XCTAssertTrue(favoriteRow.waitForExistence(timeout: 3), "Favorite city not found in favorites scope")

        favoriteRow.tap()
    }

    func test_favoritesScope_onlyShowsFavoritesAndBack() throws {
        XCUIDevice.shared.orientation = .portrait

        let searchField = app.searchFields["Search for cities"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Search bar not found")

        searchField.tap()
        searchField.typeText("London")

        let cityRow = app.buttons["cityRow_6058560"]
        XCTAssertTrue(cityRow.waitForExistence(timeout: 3), "City row not found")

        let favoritesScope = app.segmentedControls.buttons["Favorites"]
        XCTAssertTrue(favoritesScope.waitForExistence(timeout: 3), "Favorites scope not found")
        favoritesScope.tap()

        let allScope = app.segmentedControls.buttons["All"]
        XCTAssertTrue(allScope.waitForExistence(timeout: 3), "Favorites scope not found")
        allScope.tap()

        cityRow.tap()
    }

    func test_navigateToDetailAndInfo() throws {
        XCUIDevice.shared.orientation = .portrait

        sleep(3)
        let searchField = app.searchFields["Search for cities"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Search bar not found")

        searchField.tap()
        searchField.typeText("London")

        let cityRow = app.buttons["cityRow_6058560"]
        XCTAssertTrue(cityRow.waitForExistence(timeout: 3), "City row not found")

        cityRow.tap()

        let infoButton = app.buttons["infoButton"]
        XCTAssertTrue(infoButton.waitForExistence(timeout: 3), "Info button not found")

        infoButton.tap()

        let aboutText = app.staticTexts["About"]
        XCTAssertTrue(aboutText.waitForExistence(timeout: 3), "City Info Card content not loaded")
    }
}
