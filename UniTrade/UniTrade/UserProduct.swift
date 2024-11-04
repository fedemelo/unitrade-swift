import Foundation

struct UserProduct: Identifiable {
    let id: String
    let title: String
    let price: Float
    let favoritesCategory: Int
    let favoritesForYou: Int
    let imageUrl: String
    let type: String?
    
    var saveCount: Int {
        favoritesCategory + favoritesForYou
    }
}
