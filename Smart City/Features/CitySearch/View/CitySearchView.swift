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

    var body: some View {
        VStack {
            listContainer
        }
        .navigationTitle("Smart City")
        .searchable(text: $viewModel.query.animation(), prompt: "Search")
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
        List {
            ForEach(viewModel.results, id: \.id) { city in
                Button {
                    viewModel.select(city: city)
                } label: {
                    cityRow(city)
                }
                .tint(.primary)
            }
        }
        .listStyle(.insetGrouped)
        .refreshable {
            await Task{ await viewModel.loadCities(true) }.value
        }
    }
    
    private func cityRow(_ city: City) -> some View{
        SearchRowView(city: city)
            .onAppear {
                viewModel.loadMoreIfNeeded(currentItem: city)
            }
    }
}
