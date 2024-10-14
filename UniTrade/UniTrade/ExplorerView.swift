//
//  Filter.swift
//  UniTrade
//
//  Created by Santiago Martinez on 04/10/24.
//

import SwiftUI


struct ExplorerView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = ExplorerViewModel()  // ViewModel

    @State private var isFilterPresented: Bool = false  // Filter modal flag

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
                        Spacer()  // Push to the bottom
                        FilterView(isPresented: $isFilterPresented, filter: $viewModel.activeFilter)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemBackground))
                            .transition(.move(edge: .bottom))
                            .animation(.spring(), value: isFilterPresented)
                    }
                    .ignoresSafeArea(edges: .bottom)
                    .zIndex(1)  // Ensure it stays on top
                }
            }
        }
    }
}
#Preview {
    ExplorerView()
}
