import SwiftUI

struct ExplorerView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = ExplorerViewModel()
    @StateObject private var screenTimeViewModel = ScreenTimeViewModel()

    
    @State private var isFilterPresented: Bool = false  // Filter modal flag
    @State private var isLoading = true  // Track loading state
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    // Show a loading indicator while waiting for data
                    ProgressView("Loading categories and products...")
                        .font(.headline)
                } else {
                    VStack {
                        // Search Bar
                        SearchandFilterBar(
                            isFilterPresented: $isFilterPresented,
                            searchQuery: $viewModel.searchQuery,
                            isActive: viewModel.activeFilter.isActive
                        )
                        .onChange(of: viewModel.searchQuery) {
                            viewModel.selectedCategory = nil
                        }
                        
                        // Scroll View with categories and product listings
                        ScrollView {
                            VStack {
                                CategoryScroll(
                                    selectedCategory: $viewModel.selectedCategory,
                                    categories: createCategories()
                                )
                                
                                LazyVGrid(columns: columns, spacing: 32) {
                                    ForEach(viewModel.filteredProducts) { product in
                                        ListingItemView(viewModel: ListingItemViewModel(product: product))
                                    }
                                }
                                .padding()
                            }
                        }
                        .refreshable {
                            // Reload the products when the user performs a pull-to-refresh gesture
                            loadInitialData()
                        }
                    }
                    
                    // Filter modal aligned to the bottom
                    if isFilterPresented {
                        VStack {
                            Spacer()
                            FilterView(isPresented: $isFilterPresented, filter: $viewModel.activeFilter)
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemBackground))
                                .transition(.move(edge: .bottom))
                                .animation(.spring(), value: isFilterPresented)
                        }
                        .ignoresSafeArea(edges: .bottom)
                        .zIndex(1)
                    }
                }
            }
            .onAppear {
                screenTimeViewModel.startTrackingTime()
                if !viewModel.isDataLoaded {
                    loadInitialData()
                }
            }
            .onDisappear {screenTimeViewModel.stopAndRecordTime(for: "ExplorerView")}
        }
    }
    
    // Helper to create category list
    private func createCategories() -> [Category] {
        let forYouCount = viewModel.forYouCategories.count  // Use ViewModel's "For You" categories
        let forYouCategory = Category(name: "For You", itemCount: forYouCount, systemImage: "star.circle")
        
        return [
            forYouCategory,
            Category(name: "Study", itemCount: 43, systemImage: "book"),
            Category(name: "Tech", itemCount: 57, systemImage: "desktopcomputer"),
            Category(name: "Creative", itemCount: 96, systemImage: "paintbrush"),
            Category(name: "Lab", itemCount: 30, systemImage: "testtube.2"),
            Category(name: "Personal", itemCount: 78, systemImage: "backpack"),
            Category(name: "Others", itemCount: 120, systemImage: "sportscourt")
        ]
    }
    
    // Load initial data
    private func loadInitialData() {
        viewModel.loadForYouCategories { success in
            if success {
                print("'For You' categories loaded.")
                viewModel.selectedCategory = ProductCategoryGroupManager.Groups.foryou  // Set "For You" as default
            } else {
                print("Failed to load 'For You' categories.")
            }
            
            // Once categories are loaded, load the products
            viewModel.loadProductsFromFirestore()
            
            // Stop loading once both are ready
            isLoading = false
        }
    }
    
}
