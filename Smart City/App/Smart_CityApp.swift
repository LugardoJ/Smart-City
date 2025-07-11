//
//  Smart_CityApp.swift
//  Smart City
//
//  Created by Lugardo on 27/06/25.
//
import SwiftData
import SwiftUI

@main
struct Smart_CityApp: App {
    @StateObject private var coordinator: AppCoordinator = .init()

    init() {
        AppInitializer().setup()
    }

    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CityEntity.self,
            SearchHistoryEntity.self,
            LoadTimeMetricEntity.self,
            SearchMetricEntity.self,
            VisitMetricEntity.self,
            SearchLatencyEntity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView(coordinator: coordinator, sharedModelContainer: sharedModelContainer)
        }
    }
}
