import SwiftUI

class UserProductViewModel: ObservableObject, Identifiable {
    private let product: Product
    
    var id: UUID { product.id }
    var title: String { product.title }
    var imageUrl: String? { product.imageUrl }
    var formattedPrice: String { "$\(product.price)" }
    var type: String? { product.type }
    
    // Calculate the total save count
    var saveCount: Int {
        (product.favoritesCategory ?? 0) + (product.favoritesForYou ?? 0)
    }

    init(product: Product) {
        self.product = product
    }
}
