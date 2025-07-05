//
//  CitySearchViewModel.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
import SwiftData
import SwiftUI

// MARK: - ViewModel (Presentation Layer)

@Observable
final class CitySearchViewModel {
    private let searchUseCase: SearchCitiesUseCase
    private let loadUseCase: LoadRemoteCitiesUseCase
    public let inMemoryRepository: InMemoryCityRepository
    private let toggleFavoriteUseCase: ToggleFavoriteCityUseCase

    private let historyRepo: SearchHistoryRepository
    private let fetchRecentsUseCase: FetchRecentSearchesUseCase
    private let recordLoadTimeUseCase: RecordLoadTimeUseCase
    private let recordSearchTermUseCase: RecordSearchTermUseCase
    private let recordCityVisitUseCase: RecordCityVisitUseCase
    private let recordSearchLatencyUC: RecordSearchLatencyUseCase

    let context: ModelContext
    private unowned let coordinator: AppCoordinator

    var query: String = "" {
        didSet { scheduleDebouncedSearch() }
    }

    @ObservationIgnored
    private var debounceTask: Task<Void, Never>?

    var isLoading: Bool = true
    @ObservationIgnored var fullResults: [City] = []
    @ObservationIgnored var fullFavorites: [City] = []
    @ObservationIgnored var pageSize: Int = 100
    @ObservationIgnored var isLoadingMore = false

    var results: [City] = []
    @ObservationIgnored var favorites: [City] = []
    var groupedFavorites: [(key: String, value: [City])] = []
    var selectedFilter: CityFilterType = .all

    var recentQueries: [String] = []

    public var filteredRecentQueries: [String] {
        let qry = query.trimmingCharacters(in: .newlines).lowercased()
        guard !qry.isEmpty else { return recentQueries }
        return recentQueries.filter {
            $0.lowercased().hasPrefix(qry)
        }
    }

    var searchMessage: String? {
        if selectedFilter == .all {
            results.isEmpty ? "No results found for \"\(query.trimmingCharacters(in: .whitespacesAndNewlines))\"." : nil
        } else {
            groupedFavorites.isEmpty ?
                "No results found for \"\(query.trimmingCharacters(in: .whitespacesAndNewlines))\"."
                : nil
        }
    }

    // MARK: - Init

    public init(
        searchUseCase: SearchCitiesUseCase,
        loadUseCase: LoadRemoteCitiesUseCase,
        toggleFavoriteUseCase: ToggleFavoriteCityUseCase,
        inMemoryRepository: InMemoryCityRepository,
        searchHistoryRepository: SearchHistoryRepository,
        fetchRecentSearchesUseCase: FetchRecentSearchesUseCase,
        recordLoadTimeUseCase: RecordLoadTimeUseCase,
        recordSearchTermUseCase: RecordSearchTermUseCase,
        recordCityVisitUseCase: RecordCityVisitUseCase,
        recordSearchLatencyUC: RecordSearchLatencyUseCase,
        coordinator: AppCoordinator,
        context: ModelContext
    ) {
        self.searchUseCase = searchUseCase
        self.loadUseCase = loadUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.inMemoryRepository = inMemoryRepository
        historyRepo = searchHistoryRepository
        fetchRecentsUseCase = fetchRecentSearchesUseCase
        self.recordLoadTimeUseCase = recordLoadTimeUseCase
        self.recordSearchTermUseCase = recordSearchTermUseCase
        self.recordCityVisitUseCase = recordCityVisitUseCase
        self.recordSearchLatencyUC = recordSearchLatencyUC
        self.coordinator = coordinator
        self.context = context
    }

    // MARK: - Recent Queries

    @MainActor
    public func loadRecentQueries(limit: Int = 5) {
        recentQueries = fetchRecentsUseCase.execute(limit: limit)
    }

    public func recordCurrentQueryIfNeeded() {
        let term = query.trimmingCharacters(in: .newlines)
        guard term.count >= 3 else { return }
        historyRepo.registerQuery(term: term)
    }

    @MainActor
    func loadCities(_ refresh: Bool = false) async {
        let start = Date()
        isLoading = true
        let fromRemote = context.isCityCacheEmpty() || refresh
        if fromRemote {
            do {
                try await inMemoryRepository.loadCitiesRemote()
                if refresh, !fullFavorites.isEmpty {
                    inMemoryRepository.mergeFavorites(from: fullFavorites)
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
        search()
        isLoading = false
        loadRecentQueries()
        let duration = Date().timeIntervalSince(start)
        recordLoadTimeUseCase.execute(source: fromRemote ? "network" : "local", duration: duration)
    }

    private func scheduleDebouncedSearch() {
        debounceTask?.cancel()
        debounceTask = Task(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            do {
                try await Task.sleep(for: .milliseconds(250))
                search()
            } catch {
                print("Last search stop")
            }
        }
    }

    func search() {
        let start = Date.now.timeIntervalSince1970

        Task.detached(priority: .userInitiated) {
            let filtered = self.searchUseCase.execute(query: self.query)
            let prefixSlice = Array(filtered.prefix(self.pageSize))
            let favoriteSlice = Array(filtered.filter(\.isFavorite).prefix(self.pageSize))
            let duration = Date.now.timeIntervalSince1970 - start

            self.recordCurrentQueryIfNeeded()
            await MainActor.run {
                self.fullResults = filtered
                self.results = prefixSlice
                self.favorites = self.query.isEmpty ? self.fullFavorites : favoriteSlice
                self.recordSearchLatencyUC.execute(
                    query: self.query,
                    duration: duration
                )
                self.updateGroupedFavorites()

                self.isLoading = false
            }
        }
    }

    func clearRecents() {
        fetchRecentsUseCase.delete(recentQueries)
        recentQueries.removeAll()
    }

    func saveRecentQuery(_ oldQuery: String) {
        if oldQuery.trimmingCharacters(in: .newlines).count > 3 {
            recordSearchTermUseCase.execute(term: oldQuery)
            if !recentQueries.contains(oldQuery) {
                recentQueries.insert(oldQuery, at: 0)
                recentQueries = recentQueries.prefix(8).map(\.self)
            }
        }
    }

    func updateGroupedFavorites() {
        let grouped = Dictionary(grouping: favorites, by: { $0.country })

        let sortedGroups = grouped
            .sorted { $0.key < $1.key }
            .map { key, value in
                let sortedCities = value.sorted { $0.name < $1.name }
                return (key: key, value: sortedCities)
            }

        groupedFavorites = sortedGroups
    }

    func loadMoreIfNeeded(currentItem: City) {
        guard let last = results.last, currentItem.id == last.id else { return }
        loadMore()
    }

    func loadMore() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        guard results.count < fullResults.count else { return }
        let next = fullResults[results.count ..< min(results.count + pageSize, fullResults.count)]
        results.append(contentsOf: next)
        isLoadingMore = false
    }

    func toggleFavorite(item: City) {
        toggleFavoriteUseCase.execute(city: item)

        if let index = results.firstIndex(where: { $0.id == item.id }) {
            results[index].isFavorite.toggle()
        }

        if let fIndex = fullFavorites.firstIndex(where: { $0.id == item.id }) {
            fullFavorites.remove(at: fIndex)
        } else {
            fullFavorites.append(item)
        }
        if let fIndex = favorites.firstIndex(where: { $0.id == item.id }) {
            favorites.remove(at: fIndex)
        } else {
            favorites.append(item)
        }

        updateGroupedFavorites()
    }

    private func loadFavorites() {
        fullFavorites = toggleFavoriteUseCase.fetchFavorites()
    }

    func saveSelect(city: City) {
        recordCityVisitUseCase.execute(cityId: city.id)
    }

    @ObservationIgnored
    lazy var metricsDashboardViewModel: MetricsDashboardViewModel = {
        let querier: MetricsQuerying = SwiftDataMetricsQueryRepository(context: context)

        let fetchTopTermsUC = DefaultTopSearchTermsUseCase(repo: querier)
        let fetchTopCitiesUC = DefaultTopVisitedCitiesUseCase(repo: querier)
        let fetchLoadTimesUC = DefaultFetchLoadTimeMetricsUseCase(context: context)
        let fetchLatenciesUC = DefaultFetchSearchLatenciesUseCase(repo: querier)

        return MetricsDashboardViewModel(
            fetchTopTermsUseCase: fetchTopTermsUC,
            fetchTopCitiesUseCase: fetchTopCitiesUC,
            fetchLoadTimesUseCase: fetchLoadTimesUC,
            cityRepository: inMemoryRepository,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            fetchLatenciesUC: fetchLatenciesUC
        )
    }()
}
