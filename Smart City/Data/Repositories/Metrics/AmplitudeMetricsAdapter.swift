//
//  AmplitudeMetricsAdapter.swift
//  Smart City
//
//  Created by Lugardo on 02/07/25.
//
import AmplitudeSwift
import Foundation

public final class AmplitudeMetricsAdapter: MetricsRecording {
    private let amplitude: Amplitude
    
    init(keychain: KeychainManagerProtocol = DefaultKeychainManager()) {
        guard let key = keychain.read(for: .amplitudeAPIKey) else {
            fatalError("🚨 Amplitude API Key not found in Keychain.")
        }
        amplitude = .init(
            configuration:
                Configuration(
                    apiKey: key,
                    autocapture: .all)
        )
    }
    
    public func recordLoadTime(source: String, duration: TimeInterval) {
        amplitude.track(eventType: "loadTime", eventProperties: [
            "source": source,
            "duration": duration,
        ])
    }
    
    public func recordSearchTerm(_ term: String) {
        amplitude.track(eventType: "searchTerm", eventProperties: [
            "term": term,
        ])
    }
    
    public func recordSearchLatency(query: String, duration: TimeInterval) {
        amplitude.track(eventType: "searchLatency", eventProperties: [
            "query": query,
            "duration": duration,
        ])
    }
    
    public func recordCityVisit(cityId: Int) {
        amplitude.track(eventType: "cityVisit", eventProperties: [
            "city_id": cityId,
        ])
    }
    
    public func recordTimeInScreen(name: String, duration: TimeInterval) {
        amplitude.track(eventType: "screenTime", eventProperties: [
            "screen": name,
            "duration": duration,
        ])
    }
}
