//
//  CompositeMetricsRecorder.swift
//  Smart City
//
//  Created by Lugardo on 02/07/25.
//
import AmplitudeSwift
import Foundation

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

    public func recordCityVisit(cityId: Int) {
        local.recordCityVisit(cityId: cityId)
        remote.recordCityVisit(cityId: cityId)
    }
}
