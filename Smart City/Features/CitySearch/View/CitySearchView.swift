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

    var body: some View {
        VStack {
            listContainer
        }
        .navigationTitle("Smart City")
        .searchable(text: $viewModel.query.animation(), prompt: "Search")
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
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
                Button {
                    viewModel.select(city: city)
                } label: {
                    VStack(alignment: .leading) {
                        Text(city.name).bold()
                        Text(city.country).font(.subheadline).foregroundColor(.gray)
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

#Preview {
    let repository = InMemoryCityRepository()
    let searchUseCase = DefaultSearchCitiesUseCase(repository: repository)
    let loadUseCase = DefaultLoadRemoteCitiesUseCase(repository: repository)
    let viewModel = CitySearchViewModel(searchUseCase: searchUseCase,loadUseCase: loadUseCase,coordinator: AppCoordinator())
    
    NavigationStack{
        CitySearchView(viewModel: viewModel)
    }
}
