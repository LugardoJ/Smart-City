//
//  RootView.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import AmplitudeSwift
import SwiftData
import SwiftUI

public struct RootView: View {
    @State private var coordinator: AppCoordinator
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var viewModel: CitySearchViewModel
    @State private var isSearchActive: Bool = false

    private var sharedModelContainer: ModelContainer

    public init(
        coordinator: AppCoordinator,
        sharedModelContainer: ModelContainer
    ) {
        _coordinator = State(wrappedValue: coordinator)
        self.sharedModelContainer = sharedModelContainer
        let context = sharedModelContainer.mainContext

        let favoritesRepo = SwiftDataFavoritesRepository(context: context)
        let cityRepo = InMemoryCityRepository()
        let historyRepo = SwiftDataSearchHistoryRepo(context: context)
        let amplitude: Amplitude = .init(configuration:
            Configuration(
                apiKey: "d6b6f84cbc0bd82a3bc5a73a87306739",
                autocapture: .all
            ))

        let recorder: MetricsRecording = CompositeMetricsRecorder(
            local: SwiftDataMetricsRecorder(context: context),
            remote: AmplitudeMetricsAdapter(instance: amplitude)
        )

        let recordHistoryUseCase = DefaultRecordSearchTermUseCase(historyRepo: historyRepo)
        let recordMetricUseCase = DefaultRecordSearchMetricUseCase(recorder: recorder)

        let recordSearchTermUseCase = CompositeRecordSearchUseCase(
            history: recordHistoryUseCase,
            metrics: recordMetricUseCase
        )

        let fetchRecentsUseCase = DefaultFetchSearchesUseCase(historyRepo: historyRepo)
        let recordLoadTimeUseCase = DefaultRecordLoadTimeUseCase(repo: recorder)
        let recordCityVisitUseCase = DefaultRecordCityVisitUseCase(repo: recorder)
        let toggleFavoriteUseCase = DefaultToggleFavCityUseCase(favoriteRepository: favoritesRepo)
        let searchUseCase = DefaultSearchCitiesUseCase(repository: cityRepo)
        let loadUseCase = DefaultLoadRemoteCitiesUseCase(repository: cityRepo)

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
            NavigationStack(path: $coordinator.path) {
                if let city = coordinator.selectedCity {
                    let bindingCity: Binding<City> = .init {
                        city
                    } set: {
                        viewModel.toggleFavorite(item: $0)
                        coordinator.selectedCity = $0
                    }

                    CityDetailView(city: bindingCity)
                        .onAppear { viewModel.saveSelect(city: city) }
                } else {
                    ContentUnavailableView(
                        viewModel.isLoading ? "Loading data" : "Select a city",
                        systemImage: viewModel.isLoading ? "externaldrive.fill.badge.icloud" : "globe",
                        description: Text(viewModel.isLoading ? "Wait a minute" : "Tap a city to see more information.")
                    )
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .searchable(text: $viewModel.query.animation(), isPresented: $isSearchActive, prompt: "Search for cities")
        .searchScopes($viewModel.selectedFilter) {
            ForEach(CityFilterType.allCases) { scope in
                Text(scope.title).tag(scope)
            }
        }
        .onChange(of: orientation, initial: true) { _, newValue in
            columnVisibility = (newValue == .landscapeLeft || newValue == .landscapeRight)
                || coordinator.selectedCity == nil
                ? .doubleColumn : .automatic
        }
        .onChange(of: viewModel.query, initial: false) { oldValue, newValue in
            viewModel.search()
            if !oldValue.isEmpty, !isSearchActive {
                viewModel.saveRecentQuery(oldValue)
            }
            if !isSearchActive, !newValue.isEmpty {
                withAnimation {
                    isSearchActive = true
                }
            }
        }
        .onChange(of: isSearchActive, initial: false) { _, newValue in
            if !newValue {
                withAnimation {
                    viewModel.selectedFilter = .all
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
