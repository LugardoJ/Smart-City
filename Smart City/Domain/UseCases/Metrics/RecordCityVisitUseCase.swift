//
//  RecordCityVisitUseCase.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
import Foundation

public protocol RecordCityVisitUseCase {
    func execute(cityId: Int)
}

public final class DefaultRecordCityVisitUseCase: RecordCityVisitUseCase {
    private let repo: MetricsRepository

    public init(repo: MetricsRepository) {
        self.repo = repo
    }

    public func execute(cityId: Int) {
        repo.recordCityVisit(cityId: cityId)
    }
}
