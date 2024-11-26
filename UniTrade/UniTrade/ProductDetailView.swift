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
            VStack(alignment: .leading, spacing: 20) {
            // Product Image
            AsyncImage(url: URL(string: product.imageUrl ?? "")) { image in
                image
                .resizable()
                .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 350, height: 300)
            .clipped()
            .cornerRadius(10)
            
            // Title and type
            HStack {
                Text(product.title)
                .font(Font.DesignSystem.headline700)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                
                HStack {
                Text("•")
                    .font(Font.DesignSystem.headline700)
                    .foregroundColor(Color.DesignSystem.primary900())
                
                Text(product.type == "sale" ? "For Sale" : "For Rent")
                    .font(Font.DesignSystem.headline700)
                    .fontWeight(.bold)
                    .foregroundColor(Color.DesignSystem.primary900())
                }
                Spacer()
            }
            
            // Condition
            VStack(alignment: .leading) {
                Text("Condition")
                .font(Font.DesignSystem.headline500)
                .fontWeight(.bold)
                Text(product.condition)
                .font(Font.DesignSystem.bodyText200)
            }
            
            // Description
            VStack(alignment: .leading) {
                Text("Description")
                .font(Font.DesignSystem.headline500)
                .fontWeight(.bold)
                Text(product.description)
                .font(Font.DesignSystem.bodyText200)
            }
            
            // Sale or Rent details
            if product.type.lowercased() == "sale" {
                saleDetails
            } else {
                rentDetails
            }
            
            Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle(product.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    // View for products for sale
    var saleDetails: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                price
                Spacer()
                Button(action: {
                    print("Buy Now tapped for \(product.title)")
                }) {
                    ButtonWithIcon(
                        text: "BUY NOW",
                        icon: "cart"
                        // isDisabled: viewModel.isUploading || viewModel.hasValidationErrors
                    )
                }
                
            }
        }
    }
    
    // View for products for rent
    var rentDetails: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            if let rentalPeriod = product.rentalPeriod {
                VStack(alignment: .leading) {
                    Text("Rental Period")
                        .font(Font.DesignSystem.headline500)
                        .fontWeight(.bold)
                    Text("\(rentalPeriod) days")
                        .font(Font.DesignSystem.bodyText200)
                }
            }
            
            
            HStack {
                price
                Spacer()
                Button(action: {
                    print("Rent Now tapped for \(product.title)")
                }) {
                    ButtonWithIcon(
                        text: "RENT NOW",
                        icon: "cart"
                        // isDisabled: viewModel.isUploading || viewModel.hasValidationErrors
                    )
                }
            }
        }
    }
    
    var price: some View {
        VStack (alignment: .leading) {
            Text("PRICE")
                .font(Font.DesignSystem.headline500)
                .fontWeight(.bold)
            Text(CurrencyFormatter.formatPrice(product.price, currencySymbol: "COP $"))
                .font(Font.DesignSystem.bodyText300)
        }
    }
}


struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview for a product for sale
            ProductDetailView(product: Product(
                id: "1",
                title: "BatCat",
                price: 80000000.0,
                rating: 4.8,
                condition: "Miau",
                description: "Un gato único con el espíritu del Caballero Oscuro, listo para defender tu hogar de cualquier villano.",
                reviewCount: 100,
                type: "sale",
                isInStock: "yes",
                categories: "Pets, Security",
                imageUrl: "https://via.placeholder.com/300",
                favorites: 50,
                favoritesCategory: 20,
                favoritesForYou: 10
            ))
            .previewDisplayName("For Sale")
            
            // Preview for a product for rent
            ProductDetailView(product: Product(
                id: "2",
                title: "Everlast Flask",
                price: 50000.0,
                rating: 4.5,
                condition: "Almost new",
                description: "Black metallic Everlast water flask useful for carrying liquids around.",
                reviewCount: 25,
                type: "rent",
                isInStock: "yes",
                categories: "Household, Travel",
                rentalPeriod: 29,
                imageUrl: "https://via.placeholder.com/300",
                favorites: 30,
                favoritesCategory: 15,
                favoritesForYou: 5
            ))
            .previewDisplayName("For Rent")
        }
    }
}
