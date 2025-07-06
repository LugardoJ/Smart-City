//
//  MetricsDashboardUITests.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
import XCTest

final class MetricsDashboardUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func test_navigateToMetricsDashboard_andVerifyCharts() throws {
        XCUIDevice.shared.orientation = .portrait

        let metricsButton = app.buttons["metricDashboard"]
        XCTAssertTrue(metricsButton.waitForExistence(timeout: 1), "Metrics dashboard button not found")

        metricsButton.tap()

        let charts = [
            app.otherElements["topVisitedCitiesList"],
            app.otherElements["metricChart_loadTime"],
            app.otherElements["favoritesByCountry"],
            app.otherElements["searchLatencies"],
            app.otherElements["topSearchTermsList"],
        ]

        for chart in charts {
            XCTAssertTrue(chart.waitForExistence(timeout: 1), "Chart not found: \(chart.identifier)")
        }
    }

    func test_navigateToMetricsDashboard_andBack() throws {
        XCUIDevice.shared.orientation = .portrait

        let metricsButton = app.buttons["metricDashboard"]
        XCTAssertTrue(metricsButton.waitForExistence(timeout: 1), "Metrics dashboard button not found")

        metricsButton.tap()

        let charts = [
            app.otherElements["topVisitedCitiesList"],
            app.otherElements["metricChart_loadTime"],
            app.otherElements["favoritesByCountry"],
            app.otherElements["searchLatencies"],
            app.otherElements["topSearchTermsList"],
        ]

        for chart in charts {
            XCTAssertTrue(chart.waitForExistence(timeout: 1), "Chart not found: \(chart.identifier)")
        }

        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
}
