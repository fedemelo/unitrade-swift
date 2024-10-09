//
//  SearchandFilterBar.swift
//  UniTrade
//
//  Created by Santiago Martinez on 30/09/24.
//

import SwiftUI

struct SearchandFilterBar: View {
    
    @Binding var isFilterPresented: Bool
    
    var body: some View {
        HStack {
            // Magnifying Glass
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.DesignSystem.primary900())
            Spacer()
            // Text
            VStack(alignment: .leading, spacing: 2){
                Text("What are you looking for ?")
                    .font(Font.DesignSystem.bodyText300)
                    .foregroundStyle(Color.DesignSystem.primary600())
                
            }
            
            Spacer()
            // Filter Button
            Button(action: {
                isFilterPresented.toggle()
            }, label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25) // Adjust size as needed
                    .foregroundStyle(Color.DesignSystem.primary900()) // Set your custom color
            })
        }
        .padding(.horizontal)
        .padding(.vertical,15)
        .overlay{
            RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 0.8)
                .foregroundStyle(Color.DesignSystem.primary900())
        }
        .padding()
    }
}

