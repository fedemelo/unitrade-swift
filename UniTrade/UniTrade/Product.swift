//
//  Product.swift
//  UniTrade
//
//  Created by Santiago Martinez on 1/10/24.
//

import Foundation

struct Product: Identifiable {
    let id = UUID()           // Unique ID for each product
    let title: String         // Product title
    let price: String         // Product price (now a Double)
    let rating: Float         // Product rating (out of 5)
    let reviewCount: Int      // Number of reviews
    let isInStock: Bool       // Stock status
    let categories: String    // Comma-separated categories
}

extension Product {
    func value(for sortOption: String) -> Double? {
        switch sortOption {
        case "Price":
            return Double(price)  // Now a Double, no conversion needed
        case "Rating":
            return Double(rating)  // Already a Float
        default:
            return nil
        }
    }
}



