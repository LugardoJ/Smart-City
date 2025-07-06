//
//  MockRecordCityVisitUseCase.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class MockRecordCityVisitUseCase: RecordCityVisitUseCase {
    var visitedIds: [Int] = []
    func execute(cityId: Int) {
        visitedIds.append(cityId)
    }
}
