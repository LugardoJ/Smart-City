//
//  CitySearchView.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
import SwiftUI
import SwiftData
// MARK: - Views (Presentation Layer)

struct CitySearchView: View {
    @State var viewModel: CitySearchViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack {
            filterSegment
            listContainer
        }
        .loadingView(isPresented: viewModel.isLoading)
        .if(!viewModel.isLoading, transform: { content in
            content.overlay(alignment: .center){
                if let searchMessage = viewModel.searchMessage{
                    ContentUnavailableView("Search", systemImage: "magnifyingglass", description: Text(searchMessage))
                        .transition(.opacity)
                        .animation(.easeInOut, value: searchMessage)
                }
            }
        })
        .task {
            if viewModel.fullResults.isEmpty{
                await viewModel.loadCities()
            }
        }
    }
    
    private var filterSegment: some View{
        Picker("Filter", selection: $viewModel.selectedFilter.animation()) {
            ForEach(CityFilterType.allCases,id:\.id){ filter in
                Label(filter.title, systemImage: "heart")
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal,20)
    }
    
    @ViewBuilder
    private var listContainer: some View{
        switch viewModel.selectedFilter{
        case .all:
            fullResults
        case .favorites:
            SearchFavoriteListView(citiesGroup: $viewModel.groupedFavorites){ city in 
                viewModel.loadMoreIfNeeded(currentItem: city)
            }
        }
    }
    
    private var fullResults: some View {
        cityList(for: $viewModel.results)
    }

    private var favoriteResults: some View {
        cityList(for: $viewModel.favorites)
    }
    
    private func cityList(for cities: Binding<[City]>) -> some View {
        List(selection: $coordinator.selectedCity) {
            if !viewModel.filteredRecentQueries.isEmpty{
                recentSearchSection
            }
            if !viewModel.fullFavorites.isEmpty{
                citiesSection(for: cities)
            }
        }
        .listStyle(.insetGrouped)
        .refreshable {
            Task.detached(priority: .userInitiated) {
                await viewModel.loadCities(true)
            }
        }
    }
    
    private var recentSearchSection: some View{
        Section {
            ForEach(viewModel.filteredRecentQueries, id: \.self) { query in
                HStack{
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
            HStack{
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
                NavigationLink(value: city.wrappedValue) {
                    SearchRowView(city: city)
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: city.wrappedValue)
                        }
                }
                .isDetailLink(true)
            }
        } header: {
            Text("Cities").font(.headline)
        }
    }
}
