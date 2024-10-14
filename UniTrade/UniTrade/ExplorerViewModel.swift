//
//  ExplorerViewModel.swift
//  UniTrade
//
//  Created by Santiago Martinez on 1/10/24.
//


import Foundation
import SwiftUI

class ExplorerViewModel: ObservableObject {
    @Published var products: [Product] = []   // All products
    @Published var searchQuery: String = ""   // Search query
    @Published var selectedCategory: String? = nil  // Selected category
    @Published var activeFilter = Filter()    // Current active filter
    
    var filteredProducts: [Product] {
        var filtered = products
        
        // Category filtering
        if let selectedCategory = selectedCategory,
           let categoryTags = ProductCategoryGroupManager.getCategories(for: selectedCategory) {
            filtered = filtered.filter { product in
                let productCategoryArray = product.categories.components(separatedBy: ", ")
                return productCategoryArray.contains { categoryTags.contains($0) }
            }
        }
        
        // Search query filtering
        if !searchQuery.isEmpty {
            filtered = filtered.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }
        }
        
        // Price range filtering
        if let minPrice = activeFilter.minPrice,
           let maxPrice = activeFilter.maxPrice {
            filtered = filtered.filter { product in
                let price = Double(product.price) ?? 0
                return (minPrice == 0 || price >= minPrice) &&
                       (maxPrice == 0 || price <= maxPrice)
            }
        }

        // Sorting based on filter option
        if let sortOption = activeFilter.sortOption {
            switch sortOption {
            case "Price":
                filtered = activeFilter.isAscending ?
                    filtered.sorted { $0.price < $1.price } :
                    filtered.sorted { $0.price > $1.price }
            case "Rating":
                filtered = activeFilter.isAscending ?
                    filtered.sorted { $0.rating < $1.rating } :
                    filtered.sorted { $0.rating > $1.rating }
            default:
                break
            }
        }
        
        return filtered
    }

    init() {
        loadMockData()  // Initialize with mock data
    }

    func loadMockData() {
        products = [
            Product(
                title: "Bata de Laboratorio - Talla M",
                price: 40000,
                rating: 5.0,
                reviewCount: 10,
                isInStock: true,
                categories: "LAB MATERIALS, UNIFORMS"
            ),
            Product(
                title: "Microscopio Binocular",
                price: 250000,
                rating: 4.2,
                reviewCount: 23,
                isInStock: false,
                categories: "LAB MATERIALS, ELECTRONICS"
            ),
            Product(
                title: "Cuaderno Universitario - Pack de 5",
                price: 15000,
                rating: 4.0,
                reviewCount: 18,
                isInStock: true,
                categories: "NOTEBOOKS, STUDY_GUIDES"
            ),
            Product(
                title: "Estetoscopio Clásico",
                price: 95000,
                rating: 5.0,
                reviewCount: 32,
                isInStock: true,
                categories: "ELECTRONICS, LAB MATERIALS"
            ),
            Product(
                title: "Calculadora Científica",
                price: 120000,
                rating: 3.5,
                reviewCount: 5,
                isInStock: true,
                categories: "CALCULATORS, ELECTRONICS"
            )
        ]
    }
}

