//
//  RootView.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import SwiftData
import SwiftUI

public struct RootView: View {
    @State private var coordinator: AppCoordinator
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var viewModel: CitySearchViewModel
    @State private var isSearchActive: Bool = false

    private var sharedModelContainer: ModelContainer

    public init(coordinator: AppCoordinator, sharedModelContainer: ModelContainer) {
        _coordinator = State(wrappedValue: coordinator)

        self.sharedModelContainer = sharedModelContainer
        let context = sharedModelContainer.mainContext

        let favoritesRepo = SwiftDataFavoritesRepository(context: context)
        let cityRepo = InMemoryCityRepository()
        let historyRepo = SwiftDataSearchHistoryRepository(context: context)
        let metricsRepo = SwiftDataMetricsRepository(context: context)

        let searchUseCase = DefaultSearchCitiesUseCase(repository: cityRepo)
        let loadUseCase = DefaultLoadRemoteCitiesUseCase(repository: cityRepo)
        let toggleFavoriteUseCase = DefaultToggleFavoriteCityUseCase(favoriteRepository: favoritesRepo)

        let fetchRecentsUseCase = DefaultFetchRecentSearchesUseCase(historyRepo: historyRepo)
        let recordSearchTermUseCase = DefaultRecordSearchTermUseCase(historyRepo: historyRepo)

        let recordLoadTimeUseCase = DefaultRecordLoadTimeUseCase(repo: metricsRepo)
        let recordCityVisitUseCase = DefaultRecordCityVisitUseCase(repo: metricsRepo)

        _viewModel = State(wrappedValue:
            CitySearchViewModel(
                searchUseCase: searchUseCase,
                loadUseCase: loadUseCase,
                toggleFavoriteUseCase: toggleFavoriteUseCase,
                inMemoryRepository: cityRepo,
                searchHistoryRepository: historyRepo,
                fetchRecentSearchesUseCase: fetchRecentsUseCase,
                recordLoadTimeUseCase: recordLoadTimeUseCase,
                recordSearchTermUseCase: recordSearchTermUseCase,
                recordCityVisitUseCase: recordCityVisitUseCase,
                coordinator: coordinator,
                context: context
            )
        )
    }

    public var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            CitySearchView(viewModel: viewModel)
                .navigationTitle("Smart City")
                .navigationBarTitleDisplayMode(.inline)
        } detail: {
            NavigationStack {
                if let city = coordinator.selectedCity {
                    let bindingCity: Binding<City> = .init {
                        city
                    } set: { newCity in
                        viewModel.toggleFavorite(item: newCity)
                        coordinator.selectedCity = newCity
                    }
                    CityDetailView(city: bindingCity)
                } else {
                    ContentUnavailableView(viewModel.isLoading ? "Loading data" : "Select a city", systemImage: viewModel.isLoading ? "externaldrive.fill.badge.icloud" : "globe", description: Text(viewModel.isLoading ? "Wait a minute" : "Tap a city to see more information."))
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .searchable(text: $viewModel.query.animation(), isPresented: $isSearchActive, prompt: "Search for cities")
        .onChange(of: orientation, initial: true) { _, newValue in
            columnVisibility = (newValue == .landscapeLeft || newValue == .landscapeRight) || coordinator.selectedCity == nil ? .doubleColumn : .automatic
        }
        .onChange(of: viewModel.query, initial: false) { oldValue, newValue in
            self.viewModel.search()
            if !oldValue.isEmpty && !isSearchActive {
                viewModel.saveRecentQuery(oldValue)
            }
            if !isSearchActive && !newValue.isEmpty {
                withAnimation {
                    isSearchActive = true
                }
            }
        }
        .onSubmit(of: .search) {
            viewModel.saveRecentQuery(viewModel.query)
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(coordinator)
    }
}
