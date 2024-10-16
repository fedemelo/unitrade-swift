import SwiftUI

struct ExplorerView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var categoryManager = ProductCategoryGroupManager()
    @StateObject private var viewModel: ExplorerViewModel

    @State private var isFilterPresented: Bool = false  // Filter modal flag
    @State private var isLoading = true  // Track loading state

    init() {
        let categoryManager = ProductCategoryGroupManager()
        _viewModel = StateObject(wrappedValue: ExplorerViewModel(categoryManager: categoryManager))
    }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    // Show a loading indicator while waiting for categories
                    ProgressView("Loading categories...")
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
                                        ListingItemView(product: product)
                                    }
                                }
                                .padding()
                            }
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
                loadInitialData()
            }
        }
    }

    // Helper to create category list
    private func createCategories() -> [Category] {
        let forYouCount = categoryManager.forYouCategories.count
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

    // Load categories and products, and only show UI when done
    private func loadInitialData() {
        // Load "For You" categories first
        categoryManager.loadForYouCategories { success in
            if success {
                viewModel.selectedCategory = ProductCategoryGroupManager.Groups.foryou  // Set "For You" as default
                print("'For You' categories loaded.")

                // Now load products
                viewModel.loadProductsFromFirestore()
            } else {
                print("Failed to load 'For You' categories.")
            }

            // Stop loading once both are ready
            isLoading = false
        }
    }
}
