//
//  CityDetailView.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
import MapKit
import SwiftUI

/// Displays a city on a map with a delayed marker, allowing the user
/// to inspect additional information or toggle the city's favorite status.
struct CityDetailView: View {
    @Binding var city: City

    @State private var position: MapCameraPosition
    @State private var showMarker = false
    @State private var presentInfo = false

    // Initialize map region based on selected city
    init(city: Binding<City>) {
        _city = city
        _position = State(initialValue:
            MapCameraPosition.region(
                MKCoordinateRegion(
                    center: city.wrappedValue.coordinate.locationCoordinate,
                    span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                )
            )
        )
    }

    var body: some View {
        VStack {
            mapView
        }
        .padding(.top, 1)
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(.visible, for: .navigationBar)
        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onChange(of: city, initial: false) { _, newCity in
            updateMapForCity(newCity)
        }
        .inspector(isPresented: $presentInfo.animation(.bouncy)) {
            CityInfoCard(
                city: $city,
                viewModel: makeDetailViewModel()
            )
            .inspectorColumnWidth(min: 150, ideal: 400, max: 400)
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .task {
            showDelayedMarker()
        }
        .toolbar {
            toolbarButtons
        }
    }

    private func updateMapForCity(_ newCity: City) {
        showMarker = false
        position = MapCameraPosition.region(
            MKCoordinateRegion(
                center: newCity.coordinate.locationCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            )
        )
        showDelayedMarker()
    }

    private func showDelayedMarker() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                showMarker = true
            }
        }
    }

    private var mapView: some View {
        Map(position: $position, bounds: .init(minimumDistance: 10, maximumDistance: 10000)) {
            if showMarker {
                city.coordinateMarker()
                    .tint(Color.green)
            }
        }
        .mapStyle(.hybrid(elevation: .realistic))
        .mapControls {
            MapCompass()
            MapScaleView()
            MapPitchToggle()
        }
        .accessibilityIdentifier("cityMapView")
    }

    @ToolbarContentBuilder
    private var toolbarButtons: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            InfoButton(presentInfo: $presentInfo)
            FavoriteToggleButton(city: $city)
        }
    }

    private func makeDetailViewModel() -> CityDetailViewModel {
        let repository = DefaultCitySummaryRepository()
        let useCase = DefaultFetchCitySummaryUseCase(repository: repository)
        return CityDetailViewModel(fetchSummaryUseCase: useCase)
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
    NavigationStack {
        CityDetailView(city: $city)
    }
}
