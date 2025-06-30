//
//  CityInfoCard.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import SwiftUI

struct CityInfoCard: View {
    @Binding var city: City
    @Binding var isMaximized : Bool
    @State var viewModel: CityDetailViewModel

    public init(city: Binding<City>, isMaximized: Binding<Bool>, viewModel: CityDetailViewModel) {
        _city = city
        _isMaximized = isMaximized
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            if let error = viewModel.error{
                VStack(spacing: 5){
                    ContentUnavailableView(error, systemImage: "xmark.icloud.fill", description: Text("We were unable to retrieve the information from the servers (wikipedia.org)"))
                    minimizedView
                }
                .fixedSize(horizontal: false, vertical: true)
            }else{
                maximizedView
            }
        }
        .frame(maxHeight: .infinity,alignment: viewModel.error == nil ? .topLeading : .center)
        .onChange(of: city, initial: true, { _, newValue in
            Task{
                await viewModel.loadSummary(for: newValue)
            }
        })
        
    }
    
    private var maximizedView: some View{
        
        VStack(alignment: .leading,spacing: 20){
            if let summary = viewModel.summary{
                ZStack{
                    if let image = summary.originalimage?.source{
                        AsyncImage(url: URL(string: image)) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity,maxHeight: .infinity)
                                .clipped()
                                
                        } placeholder: {
                            ProgressView()
                        }
                    }else{
                        ContentUnavailableView("Image not found", systemImage: "photo.trianglebadge.exclamationmark.fill")
                    }
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 400,height: UIScreen.main.bounds.size.height * 0.3)
                .clipped()
                .cornerRadius(15, corners: [.bottomLeft,.bottomRight])

                VStack(alignment: .leading,spacing: 20){
                    HStack{
                        Text(city.name)
                            .font(.title2.bold())
                        Spacer()
                        
                        Toggle(isOn: $city.isFavorite.animation()) {
                            Image(systemName: city.isFavorite ? "heart.fill" : "heart")
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .toggleStyle(.button)
                        .tint(.red)
                    }
                    
                    HStack(spacing: 20){
                        HStack(spacing: 5){
                            Text(city.country.flagEmoji)
                                .font(.caption)
                                .padding(1)
                                .background(.regularMaterial)
                                .clipShape(.buttonBorder)
                                .shadow(radius: 1)
                            
                            Text(city.countryName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack(spacing: 5){
                            Image("pin")
                                .resizable().aspectRatio(contentMode: .fit)
                                .frame(height: 11)
                                .foregroundStyle(.secondary)
                                .padding(2)
                                .background(.regularMaterial)
                                .clipShape(.buttonBorder)
                                .shadow(radius: 1)
                            
                            Text(city.coordinateDescription)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    VStack(alignment: .leading,spacing: 10){
                        Text("About")
                            .font(.headline.bold())
                        
                        Text(summary.description ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(summary.extract)
                            .font(.caption)
                            .foregroundStyle(.primary)
                    }
                }
                .padding(.horizontal,20)
            }
        }
    }
    
    private var minimizedView: some View{
        VStack{
            Spacer()
            HStack(alignment: .top,spacing: 20){
                HStack(alignment: .top,spacing: 5){
                    Text(city.country.flagEmoji)
                        .font(.headline)
                        .padding(1)
                        .background(.regularMaterial)
                        .clipShape(.buttonBorder)
                        .shadow(radius: 1)
                    
                    VStack(alignment: .leading){
                        Text(city.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(city.countryName).foregroundStyle(.secondary)
                    }
                }
                
                HStack(alignment: .top,spacing: 5){
                    Image("pin")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(height: 11)
                        .foregroundStyle(.secondary)
                        .padding(2)
                        .background(.regularMaterial)
                        .clipShape(.buttonBorder)
                        .shadow(radius: 1)
                    
                    Text(city.coordinateDescription)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                
            }
            .padding(.horizontal,20)
            .padding(.vertical,20)
            Spacer()
        }
        .frame(maxWidth: .infinity,alignment: .center)
    }
}

#Preview {
    @Previewable @State var city = City(id: 1, name: "Tokyo", country: "JP", coord: .init(lon: 139.691711, lat: 35.689499),isFavorite: true)
    var cityDetailViewModel : CityDetailViewModel {
        let repository = DefaultCitySummaryRepository()
        let useCase = DefaultFetchCitySummaryUseCase(repository: repository)
        return CityDetailViewModel(fetchSummaryUseCase: useCase)
    }
    CityInfoCard(city: $city,isMaximized: .constant(true),viewModel: cityDetailViewModel)
        .frame(width: 400)
        .clipped()
}
