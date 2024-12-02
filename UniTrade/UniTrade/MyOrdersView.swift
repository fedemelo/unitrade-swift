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
                } else if !isConnected {
                    // Show error view when offline
                    ErrorView(message: "Failed to load errors. Please check your connection.") {
                        loadUserProducts()  // Retry action
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
            }
            .onAppear {
                setupNetworkMonitoring()
                loadUserProducts()
                screenTimeViewModel.startTrackingTime()
            }
            .onDisappear{
                screenTimeViewModel.stopAndRecordTime(for:"OrdersView")
            }
            .onDisappear {
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
