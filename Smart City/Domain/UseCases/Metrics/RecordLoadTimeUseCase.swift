//
//  RecordLoadTimeUseCase.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
import Foundation

/// Records how long it took to load a given screen or feature.
///
/// This is part of the app's performance observability.
/// Execution typically occurs once the view or data is fully rendered.
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
