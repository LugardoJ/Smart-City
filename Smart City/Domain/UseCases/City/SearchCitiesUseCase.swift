//
//  SearchCitiesUseCase.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//

/// Performs prefix-based local search across the available list of cities.
///
/// This use case is optimized for fast search by leveraging indexed in-memory collections.
/// It is invoked from the search view model after debounce.
protocol SearchCitiesUseCase {
    func execute(query: String) -> [City]
}

final class DefaultSearchCitiesUseCase: SearchCitiesUseCase {
    let repository: CityRepository

    init(repository: CityRepository) {
        self.repository = repository
    }

    func execute(query: String) -> [City] {
        repository.searchCities(matching: query)
    }
}
