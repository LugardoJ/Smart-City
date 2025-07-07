//
//  RecordCityVisitUseCase.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
import Foundation

/// Records a city visit event when a user opens a city’s detail view.
///
/// Used to measure which cities are most frequently explored by the user.
/// Events are sent to both analytics and local SwiftData repository.
public protocol RecordCityVisitUseCase {
    func execute(cityId: Int)
}

public final class DefaultRecordCityVisitUseCase: RecordCityVisitUseCase {
    private let repo: MetricsRecording

    public init(repo: MetricsRecording) {
        self.repo = repo
    }

    public func execute(cityId: Int) {
        repo.recordCityVisit(cityId: cityId)
    }
}
