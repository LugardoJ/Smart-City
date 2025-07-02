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
    private let searchHistoryRepository: SearchHistoryRepository
    private unowned let coordinator: AppCoordinator
    
    var query: String = ""
    var isLoading: Bool = true
    @ObservationIgnored var fullResults: [City] = []
    @ObservationIgnored var fullFavorites : [City] = []
    @ObservationIgnored var pageSize: Int = 100
    @ObservationIgnored var isLoadingMore = false
    
    var results: [City] = []
    @ObservationIgnored var favorites: [City] = []
    var groupedFavorites: [(key: String, value: [City])] = []
    var mostQueried: [String] = []
    
    var selectedFilter: CityFilterType = .all
    
    
    var searchMessage: String? {
        if selectedFilter == .all{
            return results.isEmpty ? "No results found for \"\(query.trimmingCharacters(in: .whitespacesAndNewlines))\"." : nil
        }else{
            return groupedFavorites.isEmpty ? "No results found for \"\(query.trimmingCharacters(in: .whitespacesAndNewlines))\"." : nil
        }
    }
    
    init(searchUseCase: SearchCitiesUseCase,loadUseCase: LoadRemoteCitiesUseCase,coordinator: AppCoordinator, inMemoryRepository: InMemoryCityRepository, context: ModelContext,toggleFavoriteUseCase: ToggleFavoriteCityUseCase,searchHistoryRepository: SearchHistoryRepository) {
        self.searchUseCase = searchUseCase
        self.loadUseCase = loadUseCase
        self.coordinator = coordinator
        self.inMemoryRepository = inMemoryRepository
        self.context = context
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.searchHistoryRepository = searchHistoryRepository
    }
    
    @MainActor
    func loadCities(_ refresh : Bool = false) async {
        isLoading = true
        if context.isCityCacheEmpty() || refresh {
            do {
                try await inMemoryRepository.loadCitiesRemote()
                if refresh && !self.fullFavorites.isEmpty{
                    inMemoryRepository.mergeFavorites(from: self.fullFavorites)
                }
                try context.cacheCities(inMemoryRepository.getCitites())
            } catch {
                print("🔴 Error loading from remote: \(error)")
            }
        } else {
            let cached = context.fetchCachedCities()
            inMemoryRepository.setCities(cached)
        }
        
        loadFavorites()
        loadMostQueried()

        search()
        isLoading = false
    }
    
    func search() {
        Task.detached(priority: .userInitiated) {
            let filtered = self.searchUseCase.execute(query: self.query)
            let prefixSlice = Array(filtered.prefix(self.pageSize))
            let favoriteSlice = Array(filtered.filter({$0.isFavorite}).prefix(self.pageSize))
            await MainActor.run {
                self.fullResults = filtered
                self.results = prefixSlice
                self.favorites = self.query.isEmpty ? self.fullFavorites : favoriteSlice
                self.updateGroupedFavorites()
                
                if !self.query.isEmpty && self.query.count > 3{
                    let trimmed = self.query.trimmingCharacters(in: .newlines)
                    self.searchHistoryRepository.registerQuery(term: trimmed)
                }
                self.isLoading = false

            }
        }
    }
    
    func updateGroupedFavorites() {
        let grouped = Dictionary(grouping: self.favorites, by: { $0.country })

        let sortedGroups = grouped
            .sorted { $0.key < $1.key }
            .map { (key, value) in
                let sortedCities = value.sorted { $0.name < $1.name }
                return (key: key, value: sortedCities)
            }

        groupedFavorites = sortedGroups
    }
    
    
    func loadMoreIfNeeded(currentItem: City) {
        guard let last = results.last else { return }
        if currentItem.id == last.id {
            loadMore()
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
    
    func toggleFavorite(item: City){
        toggleFavoriteUseCase.execute(city: item)
        
        if let index = results.firstIndex(where: { $0.id == item.id }) {
            results[index].isFavorite.toggle()
        }
        
        if let fIndex = fullFavorites.firstIndex(where: {$0.id == item.id}){
            fullFavorites.remove(at: fIndex)
        }else{
            fullFavorites.append(item)
        }
        if let fIndex = favorites.firstIndex(where: {$0.id == item.id}){
            favorites.remove(at: fIndex)
        }else{
            favorites.append(item)
        }
        
        updateGroupedFavorites()
    }
    
    private func loadFavorites(){
        fullFavorites = toggleFavoriteUseCase.fetchFavorites()
    }
    
    func loadMostQueried(limit: Int = 5) {
        mostQueried = searchHistoryRepository.fetchMostQueried(limit: limit).map { $0.term }
    }
    
    @MainActor func select(city: City) {
        coordinator.navigate(to: .cityDetail(city))
    }
}
