//
//  RecordSearchTermUseCase.swift
//  Smart City
//
//  Created by Lugardo on 01/07/25.
//
public protocol RecordSearchTermUseCase {
    func execute(term: String)
}

public final class DefaultRecordSearchTermUseCase: RecordSearchTermUseCase {
    private let historyRepo: SearchHistoryRepository

    public init(historyRepo: SearchHistoryRepository) {
        self.historyRepo = historyRepo
    }

    public func execute(term: String) {
        historyRepo.registerQuery(term: term)
    }
}
