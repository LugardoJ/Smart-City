//
//  Smart_CityApp.swift
//  Smart City
//
//  Created by Lugardo on 27/06/25.
//

import SwiftUI
import SwiftData

@main
struct Smart_CityApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([CityEntity.self,])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject private var coordinator : AppCoordinator = .init()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                CitySearchView(viewModel: viewModel)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .cityDetail(let city):
                            CityDetailView(city: city)
                        }
                    }
            }
            .environmentObject(coordinator)
        }
        .modelContainer(sharedModelContainer)
    }
    
    private var viewModel: CitySearchViewModel {
        let context = sharedModelContainer.mainContext
        
        let favoritesRepo = SwiftDataFavoritesRepository(context: context)
        let cityRepo = InMemoryCityRepository()
        
        let searchUseCase = DefaultSearchCitiesUseCase(repository: cityRepo)
        let loadUseCase = DefaultLoadRemoteCitiesUseCase(repository: cityRepo)
        let toggleFavoriteUseCase = DefaultToggleFavoriteCityUseCase(favoriteRepository: favoritesRepo)

        return CitySearchViewModel(
            searchUseCase: searchUseCase,
            loadUseCase: loadUseCase,
            coordinator: coordinator,
            inMemoryRepository: cityRepo,
            context: context,
            toggleFavoriteUseCase: toggleFavoriteUseCase
        )
    }
}
