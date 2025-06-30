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
    @Binding var selectedCity: City?
    
    var body: some View {
        VStack {
            listContainer
        }
        .navigationTitle("Smart City")
        .searchable(text: $viewModel.query.animation(),placement: .navigationBarDrawer(displayMode: .always),prompt: "Search")
        .onChange(of: viewModel.query, initial: false) { oldValue, newValue in
            self.viewModel.search()
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
    }
    
    private var listContainer: some View{
        List(selection: $coordinator.selectedCity){
            ForEach($viewModel.results, id: \.id) { city in
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
