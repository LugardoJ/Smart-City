//
//  CitySearchViewModel.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
import SwiftUI
import SwiftData

// MARK: - ViewModel (Presentation Layer)

@Observable
final class CitySearchViewModel {
    private let searchUseCase: SearchCitiesUseCase
    private let loadUseCase: LoadRemoteCitiesUseCase
    private let inMemoryRepository: InMemoryCityRepository
    private let context: ModelContext
    private let toggleFavoriteUseCase: ToggleFavoriteCityUseCase
    private unowned let coordinator: AppCoordinator
    
    var query: String = ""
    var isLoading: Bool = true
    var results: [City] = []
    @ObservationIgnored var fullResults: [City] = []
    @ObservationIgnored var pageSize: Int = 100
    @ObservationIgnored var isLoadingMore = false
        
    var searchMessage: String? {
        results.isEmpty ? "No results found for \"\(query.trimmingCharacters(in: .whitespacesAndNewlines))\"." : nil
    }
    
    init(searchUseCase: SearchCitiesUseCase,loadUseCase: LoadRemoteCitiesUseCase,coordinator: AppCoordinator, inMemoryRepository: InMemoryCityRepository, context: ModelContext,toggleFavoriteUseCase: ToggleFavoriteCityUseCase) {
        self.searchUseCase = searchUseCase
        self.loadUseCase = loadUseCase
        self.coordinator = coordinator
        self.inMemoryRepository = inMemoryRepository
        self.context = context
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }
    
    
    @MainActor
    func loadCities(_ refresh : Bool = false) async {
        isLoading = true
        if context.isCityCacheEmpty() || refresh {
            do {
                try await inMemoryRepository.loadCitiesRemote()
                try context.cacheCities(inMemoryRepository.getCitites())
            } catch {
                print("🔴 Error loading from remote: \(error)")
            }
        } else {
            let cached = context.fetchCachedCities()
            inMemoryRepository.setCities(cached)
        }
        search()
        isLoading = false
    }
    
    func search() {
        Task.detached(priority: .userInitiated) {
            let filtered = self.searchUseCase.execute(query: self.query)
            let prefixSlice = Array(filtered.prefix(self.pageSize))
            await MainActor.run {
                self.fullResults = filtered
                self.results = prefixSlice
                self.isLoading = false
            }
        }
    }
    
    func loadMore() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        guard results.count < fullResults.count else { return }
        let next = fullResults[results.count..<min(results.count + pageSize, fullResults.count)]
        results.append(contentsOf: next)
        isLoadingMore = false
    }
    
    func loadMoreIfNeeded(currentItem: City) {
        guard let last = results.last else { return }
        if currentItem.id == last.id {
            loadMore()
        }
    }
    
    func toggleFavorite(item: City){
        toggleFavoriteUseCase.execute(city: item)
        if let index = results.firstIndex(where: { $0.id == item.id }) {
            var updated = results[index]
            updated.isFavorite.toggle()
            results[index] = updated
        }
    }
    
    @MainActor func select(city: City) {
        coordinator.navigate(to: .cityDetail(city))
    }
}
