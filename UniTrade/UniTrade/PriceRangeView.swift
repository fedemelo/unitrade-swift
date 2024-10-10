//
//  PriceRangeView.swift
//  UniTrade
//
//  Created by Santiago Martinez on 1/10/24.
//
import SwiftUI

struct PriceRangeView: View {
    @Binding var minPrice: String
    @Binding var maxPrice: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Price Range")
                .font(.headline)
                .padding(.leading)
            
            HStack {
                // Min Price TextField
                VStack(alignment: .leading) {
                    Text("Min Price")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("Min", text: $minPrice)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .frame(width: 100) // Adjust as needed
                }
                
                Spacer()
                
                // Max Price TextField
                VStack(alignment: .leading) {
                    Text("Max Price")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("Max", text: $maxPrice)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .frame(width: 100) // Adjust as needed
                }
            }
            .padding()
        }
    }
}
