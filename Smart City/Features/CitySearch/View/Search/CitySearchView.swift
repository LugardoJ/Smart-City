//
//  CitySearchView.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
import SwiftUI
import TipKit

/// Main city search screen that allows users to:
/// - View all cities or just favorites
/// - See recent search history
/// - Filter cities using a floating button
/// - Navigate to city details and metrics dashboard
struct CitySearchView: View {
    @State var viewModel: CitySearchViewModel
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        VStack {
            listContainer
        }
        .modifier(EmptySearchOverlayModifier(isLoading: viewModel.isLoading, message: viewModel.searchMessage))
        .modifier(FloatingFavoritesButtonModifier(selectedFilter: $viewModel.selectedFilter))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { coordinator.navigate(to: .metricsDashboard) }) {
                    Image(systemName: "chart.bar.xaxis")
                }
                .tint(.accentColor)
                .accessibilityIdentifier("metricDashboard")
            }
        }
        .task {
            if viewModel.fullResults.isEmpty {
                await viewModel.loadCities()
            }
        }
        .onAppear {
            coordinator.selectedCity = nil
        }
    }

    @ViewBuilder
    private var listContainer: some View {
        switch viewModel.selectedFilter {
        case .all:
            cityList(for: $viewModel.results)
        case .favorites:
            SearchFavoriteListView(citiesGroup: $viewModel.groupedFavorites) {
                viewModel.loadMoreIfNeeded(currentItem: $0)
            }
        }
    }

    private func cityList(for cities: Binding<[City]>) -> some View {
        List(selection: $coordinator.selectedCity) {
            if !viewModel.filteredRecentQueries.isEmpty {
                recentSearchSection
            }
            Section(header: Text("Cities").bold().font(.headline)) {
                ForEach(cities, id: \.id) { city in
                    CityRowButton(city: city, isSelected: city.wrappedValue.id == coordinator.selectedCity?.id) {
                        coordinator.selectedCity = city.wrappedValue
                        if UIDevice.isPad {
                            coordinator.navigate(to: .cityDetail)
                        }
                    } onSwipe: {
                        viewModel.toggleFavorite(item: city.wrappedValue)
                    } onAppear: {
                        viewModel.loadMoreIfNeeded(currentItem: city.wrappedValue)
                    }
                    .id(city.id)
                }
            }
        }
        .accessibilityIdentifier("cityList")
        .listStyle(.insetGrouped)
        .refreshable {
            await viewModel.loadCities(true)
        }
    }

    private var recentSearchSection: some View {
        Section {
            ForEach(viewModel.filteredRecentQueries, id: \.self) { query in
                RecentSearchRow(query: query) {
                    withAnimation { viewModel.query = query }
                }
            }
        } header: {
            HStack {
                Text("Last search").font(.headline)
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        withAnimation { viewModel.clearRecents() }
                    }
            }
        }
    }
}
