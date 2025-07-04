//
//  RecordLoadTimeUseCase.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
import Foundation

public protocol RecordLoadTimeUseCase {
    func execute(source: String, duration: TimeInterval)
}

public final class DefaultRecordLoadTimeUseCase: RecordLoadTimeUseCase {
    private let repo: MetricsRecording

    public init(repo: MetricsRecording) {
        self.repo = repo
    }

    public func execute(source: String, duration: TimeInterval) {
        repo.recordLoadTime(source: source, duration: duration)
    }
}
