//
//  UserProductViewModel.swift
//  UniTrade
//
//  Created by Santiago Martinez on 4/11/24.
//


import SwiftUI

class UserProductViewModel: ObservableObject, Identifiable {
    private let product: UserProduct
    
    var title: String { product.title }
    var imageUrl: String? { product.imageUrl }
    var formattedPrice: String { "$\(product.price)" }
    var type: String {
        product.type == "lease" ? "For Rent" : "For Sale"
    }
    var favorites_category: Int { product.favoritesCategory}
    var favorites_foryou: Int { product.favoritesForYou}
    
    // Calculate the total save count
    var saveCount: Int { product.saveCount }
    var purchaseDate: String {"\(product.purchaseDate ?? "Not Available")"}

    init(product: UserProduct) {
        self.product = product
    }
}
