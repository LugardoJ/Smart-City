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
        let schema = Schema([
            Item.self,
        ])
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
    
    private var viewModel: CitySearchViewModel{
        let repository = InMemoryCityRepository()
        let searchUseCase = DefaultSearchCitiesUseCase(repository: repository)
        let loadUseCase = DefaultLoadRemoteCitiesUseCase(repository: repository)
        return CitySearchViewModel(searchUseCase: searchUseCase,loadUseCase: loadUseCase,coordinator: coordinator)
    }
}
