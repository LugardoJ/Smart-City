//
//  RecordSearchLatencyUseCase.swift
//  Smart City
//
//  Created by Lugardo on 03/07/25.
//
import Foundation

public protocol RecordSearchLatencyUseCase {
    func execute(query: String, duration: TimeInterval)
}

public struct DefaultRecordSearchLatencyUseCase:
    RecordSearchLatencyUseCase
{
    private let recorder: MetricsRecording
    public init(recorder: MetricsRecording) { self.recorder = recorder }
    public func execute(query: String, duration: TimeInterval) {
        recorder.recordSearchLatency(query: query, duration: duration)
    }
}
