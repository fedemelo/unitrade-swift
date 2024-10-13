//
//  ExplorerViewModel.swift
//  UniTrade
//
//  Created by Santiago Martinez on 1/10/24.
//


import Foundation
import SwiftUI

class ExplorerViewModel: ObservableObject {
    @Published var products: [Product] = []         // Full list of products
    @Published var searchQuery: String = ""         // Search query entered by the user

    // Computed property to return filtered products based on search query
    var filteredProducts: [Product] {
        if searchQuery.isEmpty {
            return products
        } else {
            return products.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }
        }	
    }

    init() {
        loadMockData()  // Initialize with mock data
    }

    func loadMockData() {
        products = [
            Product(
                title: "Bata de Laboratorio - Talla M",
                price: "40000",
                rating: 5.0,
                reviewCount: 10,
                isInStock: true,
                categories: "LAB MATERIALS, UNIFORMS"  // Category as a string
            ),
            Product(
                title: "Microscopio Binocular",
                price: "250000",
                rating: 4.2,
                reviewCount: 23,
                isInStock: false,
                categories: "LAB MATERIALS, ELECTRONICS"
            ),
            Product(
                title: "Cuaderno Universitario - Pack de 5",
                price: "15000",
                rating: 4.0,
                reviewCount: 18,
                isInStock: true,
                categories: "NOTEBOOKS, STUDY_GUIDES"
            ),
            Product(
                title: "Estetoscopio Clásico",
                price: "95000",
                rating: 5.0,
                reviewCount: 32,
                isInStock: true,
                categories: "ELECTRONICS, LAB MATERIALS"
            ),
            Product(
                title: "Calculadora Científica",
                price: "120000",
                rating: 3.5,
                reviewCount: 5,
                isInStock: true,
                categories: "CALCULATORS, ELECTRONICS"
            )
        ]
    }


}
