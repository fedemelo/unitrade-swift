import SwiftUI
import Network

struct MyOrdersView: View {
    @StateObject private var viewModel = MyOrdersViewModel()
    @State private var isLoading = true
    @StateObject private var screenTimeViewModel = ScreenTimeViewModel()
    @State private var isConnected = true
    
    private let monitor = NWPathMonitor()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    ProgressView("Loading your orders...")
                        .font(.headline)
                } else if !isConnected && viewModel.userProducts.isEmpty {
                    // Show error view when offline and no products loaded
                    ErrorView(message: "Failed to load user products. Please check your connection.") {
                        loadUserProducts() // Retry action
                    }
                } else if viewModel.userProducts.isEmpty {
                    // Show "No orders" message when there are no products
                    VStack {
                        Image(systemName: "cart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                            .padding(.bottom, 16)
                        
                        Text("You haven't made any orders yet!")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.userProducts) { product in
                                UserOrderItemView(viewModel: UserProductViewModel(product: product))
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                    .refreshable {
                        loadUserProducts()
                    }
                }
                
                // Show banner at the bottom when offline
                if !isConnected {
                    BannerView(message: "You`re viewing offline data. It may be outdated.")
                }
            }
            .onAppear {
                setupNetworkMonitoring()
                loadUserProducts()
                screenTimeViewModel.startTrackingTime()
            }
            .onDisappear {
                screenTimeViewModel.stopAndRecordTime(for: "OrdersView")
                monitor.cancel()
            }
            .navigationTitle("My Orders")
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
