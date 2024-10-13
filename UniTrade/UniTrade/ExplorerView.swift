import SwiftUI



struct ExplorerView: View {
    @StateObject private var viewModel = ExplorerViewModel()  // ViewModel with filtering logic
    @State private var selectedCategory: String? = nil        // Track selected category
    @State private var searchQuery: String = ""               // Track search query
    @State private var isFilterPresented: Bool = false        // Filter presentation flag

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // Search Bar
                    SearchandFilterBar(
                        isFilterPresented: $isFilterPresented,
                        searchQuery: $searchQuery
                    )
                    .onChange(of: searchQuery) {
                        selectedCategory = nil
                    }

                    // Scroll View containing category and product listings
                    ScrollView {
                        VStack {
                            CategoryScroll(
                                selectedCategory: $selectedCategory,
                                categories: [
                                    Category(name: "For You", itemCount: 25, systemImage: "star.circle"),
                                    Category(name: "Study", itemCount: 43, systemImage: "book"),
                                    Category(name: "Tech", itemCount: 57, systemImage: "desktopcomputer"),
                                    Category(name: "Creative", itemCount: 96, systemImage: "paintbrush"),
                                    Category(name: "Lab", itemCount: 30, systemImage: "testtube.2"),
                                    Category(name: "Personal", itemCount: 78, systemImage: "backpack"),
                                    Category(name: "Others", itemCount: 120, systemImage: "sportscourt")
                                ]
                            )

                            LazyVGrid(columns: columns, spacing: 32) {
                                ForEach(filteredProducts()) { product in
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
                        Spacer()  // Push content to the bottom
                        FilterView(isPresented: $isFilterPresented)
                            .frame(maxWidth: .infinity)  // Full-width modal
                            .background(Color(.systemBackground))  // Optional background color
                            .transition(.move(edge: .bottom))  // Slide from bottom
                            .animation(.spring(), value: isFilterPresented)
                    }
                    .ignoresSafeArea(edges: .bottom)  // Avoid any bottom padding/space
                    .zIndex(1)  // Ensure it stays above all content
                }
            }
        }
    }

    // Filter products based on selected category or search query
    private func filteredProducts() -> [Product] {
        if let selectedCategory = selectedCategory {
            if let categoryTags = ProductCategoryGroupManager.getCategories(for: selectedCategory) {
                return viewModel.products.filter { product in
                    let productCategoryArray = product.categories.components(separatedBy: ", ")
                    return productCategoryArray.contains { categoryTags.contains($0) }
                }
            }
        } else if !searchQuery.isEmpty {
            return viewModel.products.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }
        }
        return viewModel.products
    }
}

#Preview {
    ExplorerView()
}
