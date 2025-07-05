//
//  LoadRemoteCitiesUseCase.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
public protocol LoadRemoteCitiesUseCase {
    func execute() async throws
}

public final class DefaultLoadRemoteCitiesUseCase: LoadRemoteCitiesUseCase {
    private let repository: CityRepository

    public init(repository: CityRepository) {
        self.repository = repository
    }

    public func execute() async throws {
        try await repository.loadCitiesRemote()
    }
}
