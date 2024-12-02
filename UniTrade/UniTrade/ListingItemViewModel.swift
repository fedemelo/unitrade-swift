//
//  ListingItemViewModel.swift
//  UniTrade
//
//  Created by Santiago Martinez on 15/10/24.
//


import Foundation
import SwiftUI

class ListingItemViewModel: ObservableObject {
    @Published var isFavorite: Bool = false  // Track favorite state
    private let product: Product
    private let toggleFavoriteAction: (String) -> Void
    
    init(product: Product, toggleFavoriteAction: @escaping (String) -> Void) {
        self.product = product
        self.toggleFavoriteAction = toggleFavoriteAction
        self.isFavorite = product.isFavorite
    }
    
    // MARK: - Public Properties
    var title: String {
        product.title
    }
    
    var imageUrl: String? {
        product.imageUrl
    }
    
    var formattedRating: String {
        product.rating == 0.0 ? "-" : String(format: "%.1f", product.rating)
    }
    
    var reviewText: String {
        "(\(product.reviewCount) Reviews)"
    }
    
    var productType: String {
        product.type == "sale" ? "For Sale" : "For Rent"
    }
    
    // MARK: - Price Formatting Logic
    func getDecoratedPrice() -> String {
        let basePrice = BasePrice(price: Double(product.price))
        let formattedPrice = FormatDecorator(wrapped: basePrice)
        let currencyPrice = CurrencyDecorator(wrapped: formattedPrice)
        return currencyPrice.getPrice()
    }
    
    // Toggle favorite state
    func toggleFavorite() {
        isFavorite.toggle()
        toggleFavoriteAction(product.id)  // Notify ExplorerViewModel to update the product's `isFavorite`
    }
}
