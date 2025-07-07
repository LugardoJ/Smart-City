//
//  CompositeMetricsRecorder.swift
//  Smart City
//
//  Created by Lugardo on 02/07/25.
//
import Foundation

/// Combines multiple metric recorders into a single unified interface.
///
/// Useful to send the same event to both Amplitude and a local database,
/// or to A/B testing destinations.
public final class CompositeMetricsRecorder: MetricsRecording {
    private let local: MetricsRecording
    private let remote: MetricsRecording

    public init(local: MetricsRecording, remote: MetricsRecording) {
        self.local = local
        self.remote = remote
    }

    public func recordLoadTime(source: String, duration: TimeInterval) {
        local.recordLoadTime(source: source, duration: duration)
        remote.recordLoadTime(source: source, duration: duration)
    }

    public func recordSearchTerm(_ term: String) {
        local.recordSearchTerm(term)
        remote.recordSearchTerm(term)
    }

    public func recordSearchLatency(query: String, duration: TimeInterval) {
        local.recordSearchLatency(query: query, duration: duration)
        remote.recordSearchLatency(query: query, duration: duration)
    }

    public func recordCityVisit(cityId: Int) {
        local.recordCityVisit(cityId: cityId)
        remote.recordCityVisit(cityId: cityId)
    }

    public func recordTimeInScreen(name: String, duration: TimeInterval) {
        local.recordTimeInScreen(name: name, duration: duration)
        remote.recordTimeInScreen(name: name, duration: duration)
    }
}
