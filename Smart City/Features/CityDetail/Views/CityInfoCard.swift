//
//  CityInfoCard.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import SwiftUI
import Translation

/// A detailed view of a city that presents:
/// - An image (if available)
/// - Metadata (name, country, coordinates)
/// - Description from Wikipedia
/// - Optional translation support for summary
struct CityInfoCard: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var city: City
    @State var viewModel: CityDetailViewModelProtocol
    @State private var translate: Bool = false
    @State private var extractValue: String = ""

    public init(city: Binding<City>, viewModel: CityDetailViewModelProtocol) {
        _city = city
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let error = viewModel.error {
                ContentUnavailableView(
                    error,
                    systemImage: "xmark.icloud.fill",
                    description: Text("We were unable to retrieve the information from (wikipedia.org)")
                )
                .accessibilityIdentifier("cityInfoErrorView")
            } else {
                cityImageSection
                cityInfoSection
            }
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .onChange(of: city, initial: true) { _, newValue in
            Task {
                await viewModel.loadSummary(for: newValue)
            }
        }
        .onChange(of: viewModel.summary?.extract, initial: false) { _, newValue in
            if let value = newValue {
                extractValue = value
            }
        }
        .translationPresentation(isPresented: $translate, text: extractValue) { translatedText in
            extractValue = translatedText
        }
        .accessibilityIdentifier("cityInfoCard")
    }

    private var cityImageSection: some View {
        ZStack {
            if let urlString = viewModel.summary?.originalimage?.source,
               let url = URL(string: urlString)
            {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                .accessibilityIdentifier("cityImage")
            } else {
                ContentUnavailableView(
                    "Image not found",
                    systemImage: "photo.trianglebadge.exclamationmark.fill"
                )
            }
        }
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.size.height * 0.3, alignment: .center)
        .clipped()
        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
    }

    private var cityInfoSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            cityTitleAndFavoriteToggle
            cityMetadataSection
            citySummarySection
        }
        .padding(.horizontal, 20)
    }

    private var cityTitleAndFavoriteToggle: some View {
        HStack {
            Text(city.name)
                .font(.title2.bold())
            Spacer()
            Toggle(isOn: $city.isFavorite.animation()) {
                Image(systemName: city.isFavorite ? "heart.fill" : "heart")
                    .contentTransition(.symbolEffect(.replace))
            }
            .toggleStyle(.button)
            .tint(.red)
            .sensoryFeedback(.success, trigger: city.isFavorite)
            .accessibilityIdentifier("cardFavoriteToggle_\(city.id)")
        }
    }

    private var cityMetadataSection: some View {
        HStack(spacing: 20) {
            iconTextLabel(icon: city.country.flagEmoji, text: city.countryName)
            iconTextLabel(icon: "pin", text: city.coordinateDescription, isImage: true)
        }
    }

    private var citySummarySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("About")
                    .font(.headline.bold())
                Spacer()
                Button("Translate", systemImage: "translate") {
                    translate.toggle()
                }
                .tint(.teal)
                .accessibilityIdentifier("translateButton")
            }

            Text(viewModel.summary?.description ?? "")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .accessibilityIdentifier("cityInfo")
            Text(extractValue)
                .font(.caption)
                .foregroundStyle(.primary)
                .accessibilityIdentifier("cityDescription")
        }
    }

    private func iconTextLabel(icon: String, text: String, isImage: Bool = false) -> some View {
        HStack(spacing: 5) {
            if isImage {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 11)
            } else {
                Text(icon)
                    .font(.caption)
            }
        }
        .padding(2)
        .background(.regularMaterial)
        .shadow(radius: 1)
        .overlay(
            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary),
            alignment: .trailing
        )
    }
}

#Preview {
    @Previewable @State var city = City(
        id: 1,
        name: "Tokyo",
        country: "JP",
        coord: .init(lon: 139.691711, lat: 35.689499),
        isFavorite: true
    )
    var cityDetailViewModel: CityDetailViewModel {
        let repository = DefaultCitySummaryRepository()
        let useCase = DefaultFetchCitySummaryUseCase(repository: repository)
        return CityDetailViewModel(fetchSummaryUseCase: useCase)
    }
    CityInfoCard(
        city: $city,
        viewModel: cityDetailViewModel
    )
    .frame(width: 400)
    .clipped()
}
