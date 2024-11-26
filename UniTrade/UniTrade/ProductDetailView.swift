//
//  ProductDetailView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 25/11/24.
//


import SwiftUI

struct ProductDetailView: View {
    let product: Product  // The product to display
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Product Image
                AsyncImage(url: URL(string: product.imageUrl ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 300)
                .cornerRadius(10)
                
                // Product Title
                Text(product.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                // Product Condition
                Text("Condition: \(product.condition.capitalized)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                // Product Description
                Text(product.categories)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                // Additional details for Sale or Rent
                if product.type.lowercased() == "sale" {
                    // For Sale
                    saleDetails
                } else if product.type.lowercased() == "rent" {
                    // For Rent
                    rentDetails
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(product.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // View for products for sale
    private var saleDetails: some View {
        VStack(spacing: 16) {
            Text("Price")
                .font(.title2)
                .fontWeight(.bold)
            Text("COP $\(String(format: "%.0f", product.price))")
                .font(.title)
                .foregroundColor(.blue)
            
            Button(action: {
                // Handle purchase action
                print("Buy Now tapped for \(product.title)")
            }) {
                Text("BUY NOW")
                    .font(.headline)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    // View for products for rent
    private var rentDetails: some View {
        VStack(spacing: 16) {
            Text("Rental Period")
                .font(.title2)
                .fontWeight(.bold)
            Text("29 days") // Adjust based on real data if available
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Price")
                .font(.title2)
                .fontWeight(.bold)
            Text("COP $\(String(format: "%.0f", product.price))")
                .font(.title)
                .foregroundColor(.blue)
            
            Button(action: {
                // Handle rent action
                print("Rent Now tapped for \(product.title)")
            }) {
                Text("RENT NOW")
                    .font(.headline)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
