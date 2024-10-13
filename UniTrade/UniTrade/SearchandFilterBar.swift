//
//  SearchandFilterBar.swift
//  UniTrade
//
//  Created by Santiago Martinez on 30/09/24.
//

import SwiftUI

struct SearchandFilterBar: View {
    @Binding var isFilterPresented: Bool
    @Binding var searchQuery: String  // Binding to hold the search
    
    var body: some View {
        HStack {
            // Magnifying Glass Icon
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.DesignSystem.primary900())
            
            Spacer()
            // Search TextField
            TextField("What are you looking for?", text: $searchQuery)
                .font(Font.DesignSystem.bodyText300)
                .foregroundStyle(Color.DesignSystem.primary600())
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.leading, 10)
            
            Spacer()
            
            // Filter Button
            Button(action: {
                isFilterPresented.toggle()
            }, label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundStyle(Color.DesignSystem.primary900())
            })
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 0.8)
                .foregroundStyle(Color.DesignSystem.primary900())
        }
        .padding(.vertical)
        .padding(.horizontal, 30)
    }
}

