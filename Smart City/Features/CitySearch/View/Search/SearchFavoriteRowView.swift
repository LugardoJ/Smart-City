//
//  SearchFavoriteRowView.swift
//  Smart City
//
//  Created by Lugardo on 30/06/25.
//
import SwiftUI

struct SearchFavoriteRowView : View {
    @State var city : City
    
    var body: some View {
        HStack{
            Text(city.name)
                .font(.subheadline)
                .fontWeight(.semibold)
            Spacer()
            Image(systemName: "heart.fill")
                .imageScale(.small)
                .foregroundStyle(.red)
        }
        
    }
}
