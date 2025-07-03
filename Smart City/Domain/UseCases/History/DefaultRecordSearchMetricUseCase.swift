//
//  DefaultRecordSearchMetricUseCase.swift
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

public final class DefaultRecordSearchMetricUseCase: RecordSearchTermUseCase {
    private let recorder: MetricsRecording

    public init(recorder: MetricsRecording) {
        self.recorder = recorder
    }

    public func execute(term: String) {
        recorder.recordSearchTerm(term)
    }
}

public final class CompositeRecordSearchUseCase: RecordSearchTermUseCase {
    private let history: RecordSearchTermUseCase
    private let metrics: RecordSearchTermUseCase

    public init(history: RecordSearchTermUseCase, metrics: RecordSearchTermUseCase) {
        self.history = history
        self.metrics = metrics
    }

    public func execute(term: String) {
        history.execute(term: term)
        metrics.execute(term: term)
    }
}
