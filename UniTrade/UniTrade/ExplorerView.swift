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
                    // Search Bar (Esto sigue fijo)
                    SearchandFilterBar(
                        isFilterPresented: $isFilterPresented,
                        searchQuery: $searchQuery
                    )
                    .onChange(of: searchQuery) {
                        selectedCategory = nil
                    }

                    // Scroll View que contiene tanto el CategoryScroll como los productos
                    ScrollView {
                        VStack {
                            // Ahora el CategoryScroll se mueve con los productos
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

                            // Listado de productos filtrados
                            LazyVGrid(columns: columns, spacing: 32) {
                                ForEach(filteredProducts()) { product in
                                    ListingItemView(product: product)
                                }
                            }
                            .padding()
                        }
                    }
                }


                // Filter modal
                if isFilterPresented {
                    FilterView(isPresented: $isFilterPresented)
                        .transition(.move(edge: .bottom))
                        .animation(.spring(), value: isFilterPresented)
                }
            }
        }
    }

    // Filter products based on selected category or search query
    private func filteredProducts() -> [Product] {
        if let selectedCategory = selectedCategory {
            // Filter products based on selected category
            if let categoryTags = ProductCategoryGroupManager.getCategories(for: selectedCategory) {
                return viewModel.products.filter { product in
                    // Split product.categories string into an array and filter
                    let productCategoryArray = product.categories.components(separatedBy: ", ")
                    return productCategoryArray.contains { categoryTags.contains($0) }
                }
            }
        } else if !searchQuery.isEmpty {
            // Filter products based on search query (ensure searchQuery is a valid String)
            return viewModel.products.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }
        }

        // No filter: return all products
        return viewModel.products
    }

}

#Preview {
    ExplorerView()
}

