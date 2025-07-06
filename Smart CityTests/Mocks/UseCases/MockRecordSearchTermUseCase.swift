//
//  MockRecordSearchTermUseCase.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class MockRecordSearchTermUseCase: RecordSearchTermUseCase {
    var terms: [String] = []
    func execute(term: String) {
        terms.append(term)
    }
}
