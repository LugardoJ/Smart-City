//
//  MockSearchCitiesUseCase.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class MockSearchCitiesUseCase: SearchCitiesUseCase {
    var queryReceived: String?
    var result: [City] = [City.mock(name: "Search Result")]

    func execute(query: String) -> [City] {
        queryReceived = query
        return result
    }
}
