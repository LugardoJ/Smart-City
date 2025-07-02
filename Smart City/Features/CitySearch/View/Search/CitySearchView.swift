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
    @State private var isSearchActive: Bool = false
    
    var body: some View {
        VStack {
            filterSegment
            listContainer
        }
        .searchable(text: $viewModel.query.animation(),prompt: "Search"){
            ForEach(viewModel.mostQueried, id: \.self) { result in
                Text("Are you looking for \(result)?").searchCompletion(result)
            }
        }
        .LoadingView(isPresented: viewModel.isLoading)
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
        .onChange(of: viewModel.query, initial: false) { oldValue, newValue in
            self.viewModel.search()
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
            ForEach(cities, id: \.id) { city in
                NavigationLink(value: city.wrappedValue) {
                    SearchRowView(city: city)
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: city.wrappedValue)
                        }
                }
                .isDetailLink(true)
            }
        }
        .listStyle(.insetGrouped)
        .refreshable {
            Task.detached(priority: .userInitiated) {
                await viewModel.loadCities(true)
            }
        }
    }
}
