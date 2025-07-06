//
//  MockRecordLoadTimeUseCase.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
@testable import Smart_City
import XCTest

final class MockRecordLoadTimeUseCase: RecordLoadTimeUseCase {
    var recordedCalls: [(source: String, duration: TimeInterval)] = []

    func execute(source: String, duration: TimeInterval) {
        recordedCalls.append((source, duration))
    }
}
