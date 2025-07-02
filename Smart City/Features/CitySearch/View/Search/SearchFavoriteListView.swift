//
//  SearchFavoriteListView.swift
//  Smart City
//
//  Created by Lugardo on 30/06/25.
//
import SwiftUI

struct SearchFavoriteListView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @Binding var citiesGroup :  [(key: String, value: [City])]
    var onRefresh: (_ city: City) -> Void
    
    var body: some View {
        List(selection: $coordinator.selectedCity) {
            ForEach(Array(citiesGroup),id:\.key){ group in
                Section(header: Text(group.key.flagEmoji + group.key)) {
                    ForEach(group.value,id:\.id){ city in
                        NavigationLink(value: city) {
                            SearchFavoriteRowView(city: city)
                                .onAppear{
                                    onRefresh(city)
                                }
                        }
                        .isDetailLink(true)
                    }
                }
                .headerProminence(.increased)
            }
        }
        .listStyle(.insetGrouped)
        
    }
}
