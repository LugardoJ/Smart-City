//
//  CompactLandscapeView.swift
//  Smart City
//
//  Created by Lugardo on 03/07/25.
//
import SwiftUI

struct CompactLandscapeView: View {
    @State var viewModel: CitySearchViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    @Environment(\.horizontalSizeClass) var hSizeClass
    @Environment(\.verticalSizeClass) var vSizeClass

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            compactView
                .navigationTitle("Smart City")
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .cityDetail:
                        detailWrapperView
                    case .metricsDashboard:
                        MetricsDashboardView(
                            viewModel: viewModel.metricsDashboardViewModel
                        )
                    }
                }
        }
    }

    private var compactView: some View {
        Group {
            if hSizeClass == .compact, !isCompactIphoneLandscape {
                citySearchContent
                    .onChange(of: coordinator.selectedCity, initial: false) { _, newValue in
                        if newValue != nil, coordinator.current() != .cityDetail {
                            coordinator.navigate(to: .cityDetail)
                        }
                    }
            } else {
                HStack(spacing: 5) {
                    citySearchContent
                        .frame(width: 300)
                    detailWrapperView
                }
                .background(.bar)
            }
        }
    }

    private var citySearchContent: some View {
        CitySearchView(viewModel: viewModel)
            .frame(maxWidth: .infinity)
    }

    private var detailWrapperView: some View {
        Group {
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

    private var isCompactIphoneLandscape: Bool {
        hSizeClass == .compact && vSizeClass == .compact
    }
}
