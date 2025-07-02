//
//  RootView.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import SwiftUI
import SwiftData

public struct RootView: View {
    @State private var coordinator: AppCoordinator
    @State private var columnVisibility : NavigationSplitViewVisibility = .automatic
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var viewModel: CitySearchViewModel
    
    private var sharedModelContainer: ModelContainer

    public init(coordinator: AppCoordinator, sharedModelContainer: ModelContainer) {
        _coordinator = State(wrappedValue: coordinator)

        self.sharedModelContainer = sharedModelContainer
        let context = sharedModelContainer.mainContext

        let favoritesRepo = SwiftDataFavoritesRepository(context: context)
        let cityRepo = InMemoryCityRepository()
        
        let searchUseCase = DefaultSearchCitiesUseCase(repository: cityRepo)
        let loadUseCase = DefaultLoadRemoteCitiesUseCase(repository: cityRepo)
        let toggleFavoriteUseCase = DefaultToggleFavoriteCityUseCase(favoriteRepository: favoritesRepo)
        
        let searchHistoryRepository = SwiftDataSearchHistoryRepository(context: context)

        _viewModel = State(wrappedValue:
                            CitySearchViewModel(
                                searchUseCase: searchUseCase,
                                loadUseCase: loadUseCase,
                                coordinator: coordinator,
                                inMemoryRepository: cityRepo,
                                context: context,
                                toggleFavoriteUseCase: toggleFavoriteUseCase,
                                searchHistoryRepository: searchHistoryRepository
                            )
        )
    }
    
    public var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility){
            CitySearchView(viewModel: viewModel)
                .navigationTitle("Smart City")
                .navigationBarTitleDisplayMode(.inline)
        }detail: {
            NavigationStack{
                if let city = coordinator.selectedCity{
                    let bindingCity : Binding<City> = .init {
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
        .onChange(of: orientation, initial: true, { oldValue, newValue in
            columnVisibility = (newValue == .landscapeLeft || newValue == .landscapeRight) || coordinator.selectedCity == nil ? .doubleColumn : .automatic
        })
        .onRotate { newOrientation in
            orientation = newOrientation
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(coordinator)
    }
    
}
