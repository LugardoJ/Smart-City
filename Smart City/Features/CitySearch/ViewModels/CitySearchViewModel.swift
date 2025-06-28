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
    private let searchUseCase: SearchCitiesUseCase
    private unowned let coordinator: AppCoordinator
    private let loadUseCase: LoadRemoteCitiesUseCase
    
    var query: String = ""
    var isLoading: Bool = false
    var results: [City] = []
    @ObservationIgnored var fullResults: [City] = []
    @ObservationIgnored var pageSize: Int = 100

    var searchMessage: String? {
        results.isEmpty ? "No results found for \"\(query.trimmingCharacters(in: .whitespacesAndNewlines))\"." : nil
    }
    
    init(searchUseCase: SearchCitiesUseCase,loadUseCase: LoadRemoteCitiesUseCase,coordinator: AppCoordinator) {
        self.searchUseCase = searchUseCase
        self.loadUseCase = loadUseCase
        self.coordinator = coordinator
    }
    
    @MainActor
    func loadCities() async {
        isLoading = true
        do {
            try await loadUseCase.execute()
            search()
        } catch {
            print("Error loading remote cities: \(error)")
        }
    }
    
    func search() {
        Task.detached(priority: .userInitiated) {
            let filtered = self.searchUseCase.execute(query: self.query)
            self.fullResults = filtered
            await MainActor.run {
                self.results = Array(filtered.prefix(self.pageSize))
                self.isLoading = false
            }
        }
    }
    
    func loadMore() {
        guard results.count < fullResults.count else { return }
        let next = fullResults[results.count..<min(results.count + pageSize, fullResults.count)]
        results.append(contentsOf: next)
    }
    
    func loadMoreIfNeeded(currentItem: City) {
        guard let last = results.last else { return }
        if currentItem.id == last.id {
            loadMore()
        }
    }
    
    @MainActor func select(city: City) {
        coordinator.navigate(to: .cityDetail(city))
    }
}
