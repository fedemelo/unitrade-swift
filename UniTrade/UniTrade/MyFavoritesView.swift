//
//  MyFavoritesView.swift
//  UniTrade
//
//  Created by Santiago Martinez on 2/12/24.
//

import SwiftUI
import Network

struct MyFavoritesView: View {
    @StateObject private var viewModel = MyFavoritesViewModel()
    @State private var isLoading = true
    @State private var isConnected = true
    private let monitor = NWPathMonitor()

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    ProgressView("Loading your favorite products...")
                        .font(.headline)
                } else if !isConnected {
                    // Show error view when offline
                    ErrorView(
                        message: "You are offline. Please check your connection."
                    )
                } else if viewModel.favoriteProducts.isEmpty {
                    // Fallback UI for no favorites
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        
                        Text("You have no favorites yet!")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Start adding products to your favorites by tapping the heart icon.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                } else {
                    // Display favorites in grid layout
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.favoriteProducts) { product in
                                NavigationLink(destination: ProductDetailView(
                                    viewModel: ProductDetailViewModel(),
                                    product: product,
                                    onDismiss: {
                                        loadFavoriteProducts()  // Reload products when returning
                                    }
                                )) {
                                    ListingItemView(viewModel: ListingItemViewModel(product: product) { productId in
                                        viewModel.toggleFavorite(productId: productId)
                                    })
                                }
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        loadFavoriteProducts()
                    }
                }
            }
            .onAppear {
                setupNetworkMonitoring()
                loadFavoriteProducts()
            }
            .onDisappear {
                monitor.cancel()
            }
            .navigationTitle("My Favorites")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func loadFavoriteProducts() {
        guard isConnected else {
            isLoading = false
            return
        }
        
        isLoading = true
        viewModel.loadFavorites { success, error in
            isLoading = false
            if let error = error {
                // Log errors to the console but avoid showing them to the user
                print("Error loading favorites: \(error)")
            }
        }
    }

    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                if !self.isConnected {
                    self.isLoading = false
                }
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
