//
//  ProductDetailView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 02/12/24.
//

import SwiftUI

struct ProductDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ProductDetailViewModel
    let product: Product
    
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
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Status"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK")) {
                    viewModel.dismissAction = {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
    
    // View for products for sale
    var saleDetails: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                price
                Spacer()
                Button(action: {
                    viewModel.handleBuyNow(for: product)
                }) {
                    ButtonWithIcon(
                        text: "BUY NOW",
                        icon: "cart"
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
                    viewModel.handleRentNow(for: product)
                }) {
                    ButtonWithIcon(
                        text: "RENT NOW",
                        icon: "cart"
                    )
                }
            }
        }
    }
    
    var price: some View {
        VStack(alignment: .leading) {
            Text("PRICE")
                .font(Font.DesignSystem.headline500)
                .fontWeight(.bold)
            Text(CurrencyFormatter.formatPrice(product.price, currencySymbol: "COP $"))
                .font(Font.DesignSystem.bodyText300)
        }
    }
}
