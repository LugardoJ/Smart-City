//
//  MockRecordSearchLatencyUseCase.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class MockRecordSearchLatencyUseCase: RecordSearchLatencyUseCase {
    var data: [(query: String, duration: TimeInterval)] = []
    func execute(query: String, duration: TimeInterval) {
        data.append((query, duration))
    }
}
