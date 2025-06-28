//
//  SearchCitiesUseCase.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
// MARK: - Use Cases (Domain Layer)

protocol SearchCitiesUseCase {
    func execute(query: String) -> [City]
}

// MARK: - Use Case Implementations (Domain Layer)

final class DefaultSearchCitiesUseCase: SearchCitiesUseCase {
    private let repository: CityRepository
    
    init(repository: CityRepository) {
        self.repository = repository
    }
    func execute(query: String) -> [City] {
        repository.searchCities(matching: query)
    }
}
