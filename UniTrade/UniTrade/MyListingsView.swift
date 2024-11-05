//
//  MyListingsView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 19/10/24.
//

import SwiftUI
import Network

struct MyListingsView: View {
    @StateObject private var viewModel = MyListingsViewModel()
    @State private var isLoading = true
    @StateObject private var screenTimeViewModel = ScreenTimeViewModel()
    @State private var isConnected = true
    
    private let monitor = NWPathMonitor()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    ProgressView("Loading your products...")
                        .font(.headline)
                } else if !isConnected {
                    // Show error view when offline
                    ErrorView(message: "Failed to load products. Please check your connection.") {
                        loadUserProducts()  // Retry action
                    }
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
                setupNetworkMonitoring()
                loadUserProducts()
                screenTimeViewModel.startTrackingTime()
            }
            .onDisappear{
                screenTimeViewModel.stopAndRecordTime(for:"ListingView")
            }
            .onDisappear {
                monitor.cancel()
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
