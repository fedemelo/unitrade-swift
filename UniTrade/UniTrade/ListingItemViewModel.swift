import Foundation
import SwiftUI

class ListingItemViewModel: ObservableObject {
    @Published var isFavorite: Bool = false  // Track favorite state
    private let product: Product
    
    init(product: Product) {
        self.product = product
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
    
    var stockStatus: String {
        product.isInStock == "lease" ? "For Rent" : "For Sale"
    }
    
    // MARK: - Price Formatting Logic
    func getDecoratedPrice() -> String {
        let basePrice = BasePrice(price: product.price)
        let formattedPrice = FormatDecorator(wrapped: basePrice)
        let currencyPrice = CurrencyDecorator(wrapped: formattedPrice)
        return currencyPrice.getPrice()
    }
    
    // Toggle favorite state
    func toggleFavorite() {
        isFavorite.toggle()
    }
}
