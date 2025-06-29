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
        .LoadingView(isPresented: viewModel.isLoading)
        .if(!viewModel.isLoading, transform: { content in
            content.overlay(alignment: .center, content: {
                if let searchMessage = viewModel.searchMessage{
                    ContentUnavailableView("Search", systemImage: "magnifyingglass", description: Text(searchMessage))
                        .transition(.opacity)
                        .animation(.easeInOut, value: searchMessage)
                }
            })
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
                HStack{
                    Button {
                        viewModel.select(city: city)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(city.name).bold()
                            Text(city.country).font(.subheadline).foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                    }                    
                    
                    Image(systemName: city.isFavorite == true ? "bookmark.fill" : "bookmark")
                        .onTapGesture {
                            withAnimation {
                                viewModel.toggleFavorite(item: city)
                            }
                        }
                    
                }
                .onAppear {
                    viewModel.loadMoreIfNeeded(currentItem: city)
                }
            }
        }
        .listStyle(.insetGrouped)
        .onChange(of: viewModel.query, initial: false) { oldValue, newValue in
            self.viewModel.search()
        }
    }
}
