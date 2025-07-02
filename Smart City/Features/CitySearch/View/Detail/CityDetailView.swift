//
//  CityDetailView.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
import MapKit
import SwiftUI

// MARK: - Views (Presentation Layer)

struct CityDetailView: View {
    @Binding var city: City

    @State private var position = MapCameraPosition.region(.init())
    @State private var showMarker: Bool = false
    @State private var presentInfo: Bool = false

    init(city: Binding<City>) {
        _city = city
        _position = State(initialValue:
            MapCameraPosition.region(
                MKCoordinateRegion(
                    center: city.wrappedValue.coordinate.locationCoordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 1,
                        longitudeDelta: 1
                    )
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
        .onChange(of: city, initial: false) { _, newValue in
            showMarker = false
            position = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: newValue.coordinate.locationCoordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 1,
                        longitudeDelta: 1
                    )
                )
            )
            showDelayMarker()
        }
        .inspector(isPresented: $presentInfo.animation(.bouncy), content: {
            CityInfoCard(city: $city, isMaximized: .constant(true), viewModel: cityDetailViewModel())
                .inspectorColumnWidth(min: 150, ideal: 400, max: 400)
                .presentationDetents([.large])
        })
        .task {
            showDelayMarker()
        }
        .toolbar {
            toolbarItems
        }
    }

    private func showDelayMarker() {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
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
    }

    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                withAnimation(.bouncy) {
                    presentInfo.toggle()
                }
            } label: {
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.white, .blue)
            }

            Button {
                withAnimation {
                    city.isFavorite.toggle()
                }
            } label: {
                Image(systemName: city.isFavorite ? "heart.fill" : "heart")
                    .contentTransition(.symbolEffect(.replace))
            }
            .tint(city.isFavorite ? .red : .accentColor)
        }
    }

    private func cityDetailViewModel() -> CityDetailViewModel {
        let repository = DefaultCitySummaryRepository()
        let useCase = DefaultFetchCitySummaryUseCase(repository: repository)
        return CityDetailViewModel(fetchSummaryUseCase: useCase)
    }
}

#Preview {
    @Previewable @State var city = City(id: 1, name: "Tokyo", country: "JP", coord: .init(lon: 139.691711, lat: 35.689499), isFavorite: true)
    NavigationStack {
        CityDetailView(city: $city)
    }
}
