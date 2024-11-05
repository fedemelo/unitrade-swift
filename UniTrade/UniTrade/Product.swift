//
//  Product.swift
//  UniTrade
//
//  Created by Santiago Martinez on 1/10/24.
//

import Foundation

struct Product: Identifiable {
    let id: UUID
    let title: String
    let price: Float
    let rating: Float       
    let reviewCount: Int
    let isInStock: String
    let categories: String
    let imageUrl: String?
    var isFavorite: Bool = false

    init(
        id: UUID = UUID(),
        title: String,
        price: Float,
        rating: Float,
        reviewCount: Int,
        isInStock: String,
        categories: String,
        imageUrl: String? = nil,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.price = price
        self.rating = rating
        self.reviewCount = reviewCount
        self.isInStock = isInStock
        self.categories = categories
        self.imageUrl = imageUrl
        self.isFavorite = isFavorite
    }
}

extension Product {

    func value(for sortOption: String) -> Float? {
        switch sortOption {
        case "Price":
            return price
        case "Rating":
            return rating
        default:
            return nil
        }
    }
}
