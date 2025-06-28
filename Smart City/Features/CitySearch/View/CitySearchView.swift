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
            List(viewModel.results,id:\.id) { city in
                Button {
                    viewModel.select(city: city)
                } label: {
                    VStack(alignment: .leading) {
                        Text(city.name).bold()
                        Text(city.country).font(.subheadline).foregroundColor(.gray)
                    }
                }
            }
            .onChange(of: viewModel.query, initial: false) { oldValue, newValue in
                viewModel.search()
            }
        }
        .navigationTitle("Smart City")
        .searchable(text: $viewModel.query, prompt: "Search")
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
        .task {
            await viewModel.loadCities()
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
