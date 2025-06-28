//
//  CitySearchViewModel.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
import SwiftUI

// MARK: - ViewModel (Presentation Layer)

@Observable
final class CitySearchViewModel {
    var query: String = ""
    var results: [City] = []

    private let searchUseCase: SearchCitiesUseCase
    private unowned let coordinator: AppCoordinator
    private let loadUseCase: LoadRemoteCitiesUseCase

    init(searchUseCase: SearchCitiesUseCase,loadUseCase: LoadRemoteCitiesUseCase,coordinator: AppCoordinator) {
      self.searchUseCase = searchUseCase
      self.loadUseCase = loadUseCase
      self.coordinator = coordinator
    }

    @MainActor
    func loadCities() async {
        do {
            try await loadUseCase.execute()
            search()
        } catch {
            print("Error loading remote cities: \(error)")
        }
    }
    
    func search() {
        let currentQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        DispatchQueue.global(qos: .userInitiated).async {
            let filtered = self.searchUseCase.execute(query: currentQuery)
            DispatchQueue.main.async {
                self.results = filtered
            }
        }
    }

    @MainActor func select(city: City) {
        coordinator.navigate(to: .cityDetail(city))
    }
}
