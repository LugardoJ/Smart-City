//
//  LoadRemoteCitiesUseCase.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
/// Loads the full list of cities from a remote JSON source.
///
/// Typically used on app launch to populate the in-memory index with 200K+ entries.
/// Fallback or retry strategies can be layered here.
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
