//
//  FilterView.swift
//  UniTrade
//
//  Created by Santiago Martinez on 1/10/24.
//
import SwiftUI

struct FilterView: View {
    @Binding var isPresented: Bool
    @State private var selectedSortOption: String = "Rating"
    @State private var minPrice: String = ""
    @State private var maxPrice: String = ""
    
    let sortOptions = ["RATING", "BRAND", "NOVELTY", "POPULARITY"]

    var body: some View {
        VStack(alignment: .leading) {
            
            PriceRangeView(minPrice: $minPrice, maxPrice: $maxPrice)
                            .padding(.bottom, 20)
            Text("Sort By")
                .font(.headline)
                .padding(.bottom, 10)
                .padding(.leading)
            
            // Sort buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(sortOptions, id: \.self) { option in
                        SortButton(
                            title: option,
                            isSelected: option == selectedSortOption,
                            onTap: {
                                selectedSortOption = option
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Action buttons (Reset and Apply)
            HStack {
                Button(action: {
                    // Reset logic here
                    selectedSortOption = "RATING"
                }) {
                    Text("RESET")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(Color.blue)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }
                
                Button(action: {
                    // Apply logic here
                    isPresented.toggle()
                }) {
                    Text("APPLY")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .frame(maxHeight: 600)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 10)
        .offset(y: isPresented ? 0 : UIScreen.main.bounds.height)
        .animation(.easeInOut, value: isPresented)
    }
}
