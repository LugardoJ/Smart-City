//
//  LoadRemoteCitiesUseCase.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
protocol LoadRemoteCitiesUseCase {
    func execute() async throws
}

final class DefaultLoadRemoteCitiesUseCase: LoadRemoteCitiesUseCase {
    private let repository: CityRepository

    init(repository: CityRepository) {
        self.repository = repository
    }

    func execute() async throws {
        try await repository.loadCitiesRemote()
    }
}
