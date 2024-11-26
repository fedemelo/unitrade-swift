//
//  Product.swift
//  UniTrade
//
//  Created by Santiago Martinez on 1/10/24.
//

import Foundation

struct Product: Identifiable {
    let id: String
    let title: String
    let price: Float
    let rating: Float
    let condition: String
    let reviewCount: Int
    let type: String
    let isInStock: String
    let categories: String
    let imageUrl: String?
    var isFavorite: Bool = false
    let favorites: Int
    let favoritesCategory: Int
    let favoritesForYou : Int

    init(
        id: String,
        title: String,
        price: Float,
        rating: Float,
        condition: String,
        reviewCount: Int,
        type: String,
        isInStock: String,
        categories: String,
        imageUrl: String? = nil,
        isFavorite: Bool = false,
        favorites: Int = 0,
        favoritesCategory: Int = 0,
        favoritesForYou: Int = 0
    ) {
        self.id = id
        self.title = title
        self.price = price
        self.rating = rating
        self.condition = condition
        self.reviewCount = reviewCount
        self.type = type
        self.isInStock = isInStock
        self.categories = categories
        self.imageUrl = imageUrl
        self.isFavorite = isFavorite
        self.favorites = favorites
        self.favoritesCategory = favoritesCategory
        self.favoritesForYou = favoritesForYou
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
