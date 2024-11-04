//
//  MyListingsView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 19/10/24.
//

import SwiftUI

struct MyListingsView: View {
    @StateObject private var viewModel = MyListingsViewModel()
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    ProgressView("Loading your products...")
                        .font(.headline)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.userProducts) { product in
                                UserProductItemView(viewModel: UserProductViewModel(product: product))
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                    .refreshable {
                        loadUserProducts()
                    }
                }
            }
            .onAppear {
                loadUserProducts()
            }
            .navigationTitle("My Products")
        }
    }
    
    // Load only the products for the current user
    private func loadUserProducts() {
        isLoading = true
        viewModel.loadUserProducts()
        isLoading = false
    }
}
