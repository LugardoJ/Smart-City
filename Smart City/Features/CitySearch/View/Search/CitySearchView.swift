//
//  CitySearchView.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
import SwiftUI

// MARK: - Views (Presentation Layer)

struct CitySearchView: View {
    @State var viewModel: CitySearchViewModel
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        VStack {
            listContainer
        }
        .loadingView(isPresented: viewModel.isLoading)
        .if(!viewModel.isLoading, transform: { content in
            content.overlay(alignment: .center) {
                if let searchMessage = viewModel.searchMessage {
                    ContentUnavailableView(
                        "Search",
                        systemImage: "magnifyingglass",
                        description: Text(searchMessage)
                    )
                    .transition(.opacity)
                    .animation(.easeInOut, value: searchMessage)
                }
            }
        })
        .overlay(alignment: .bottomTrailing, content: {
            Button {
                withAnimation {
                    viewModel.selectedFilter =
                        viewModel.selectedFilter == .favorites
                            ? .all : .favorites
                }
            } label: {
                Image(systemName: viewModel.selectedFilter == .favorites ? "heart.fill" : "heart")
                    .font(.title.weight(.semibold))
                    .padding(5)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        viewModel.selectedFilter == .favorites
                            ? .red : .secondary,
                        .white
                    )
                    .background(.white)
                    .clipShape(.circle)
                    .shadow(radius: 3)
            }
            .padding()
            .contentTransition(.symbolEffect(.replace))

        })
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    coordinator.navigate(to: .metricsDashboard)
                } label: {
                    Image(systemName: "chart.pie.fill")
                }
                .tint(.green)
            }
        }
        .task {
            if viewModel.fullResults.isEmpty {
                await viewModel.loadCities()
            }
        }
    }

    private var listContainer: some View {
        Group {
            switch viewModel.selectedFilter {
            case .all:
                fullResults
            case .favorites:
                SearchFavoriteListView(citiesGroup: $viewModel.groupedFavorites) { city in
                    viewModel.loadMoreIfNeeded(currentItem: city)
                }
            }
        }
    }

    private var fullResults: some View {
        cityList(for: $viewModel.results)
    }

    private func cityList(for cities: Binding<[City]>) -> some View {
        List(selection: $coordinator.selectedCity) {
            if !viewModel.filteredRecentQueries.isEmpty {
                recentSearchSection
            }
            citiesSection(for: cities)
        }
        .listStyle(.insetGrouped)
        .refreshable {
            Task.detached(priority: .userInitiated) {
                await viewModel.loadCities(true)
            }
        }
    }

    private var recentSearchSection: some View {
        Section {
            ForEach(viewModel.filteredRecentQueries, id: \.self) { query in
                HStack {
                    Image(systemName: "clock")
                        .imageScale(.small)
                        .foregroundStyle(.secondary)
                    Text(query)
                        .font(.body)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: "arrow.up.left")
                        .foregroundStyle(.secondary)
                        .opacity(0.5)
                }
                .contentShape(.capsule)
                .onTapGesture {
                    withAnimation {
                        viewModel.query = query
                    }
                }
            }
        } header: {
            HStack {
                Text("Last search").font(.headline)

                Spacer()

                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        withAnimation {
                            viewModel.clearRecents()
                        }
                    }
            }
        }
    }

    private func citiesSection(for cities: Binding<[City]>) -> some View {
        Section {
            ForEach(cities, id: \.id) { city in
                SearchRowView(city: city, selected: .constant(city.wrappedValue.id == coordinator.selectedCity?.id))
                    .contentShape(.buttonBorder)
                    .onAppear {
                        viewModel.loadMoreIfNeeded(currentItem: city.wrappedValue)
                    }
                    .onTapGesture {
                        coordinator.selectedCity = city.wrappedValue
                        if UIDevice.isPad {
                            coordinator.navigate(to: .cityDetail)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            withAnimation {
                                viewModel.toggleFavorite(item: city.wrappedValue)
                            }
                        } label: {
                            Image(systemName:
                                city.wrappedValue.isFavorite
                                    ? "heart.slash" : "heart.fill")
                        }
                        .tint(.red)
                        .sensoryFeedback(.success, trigger: city.wrappedValue.isFavorite)
                    }
            }
        } header: {
            Text("Cities")
                .bold()
                .font(.headline)
        }
    }
}
