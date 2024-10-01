//
//  CategoryScroll.swift
//  UniTrade
//
//  Created by Santiago Martinez on 30/09/24.
//

import SwiftUI

struct CategoryScroll: View {
    @State private var selectedCategory: Category?

    // Sample categories data
    let categories: [Category] = [
            Category(name: "For You", itemCount: 25, systemImage: "star.circle"),
            Category(name: "Study", itemCount: 43, systemImage: "book"),
            Category(name: "Tech", itemCount: 57, systemImage: "desktopcomputer"),
            Category(name: "Creative", itemCount: 96, systemImage: "paintbrush"),
            Category(name: "Lab", itemCount: 30, systemImage: "testtube.2"),
            Category(name: "Personal", itemCount: 78, systemImage: "backpack"),
            Category(name: "Others", itemCount: 120, systemImage: "sportscourt")
        ]

    var body: some View {
        VStack {
            Text("Categories")
                .font(Font.DesignSystem.headline700)
                .bold()
                .foregroundStyle(Color.DesignSystem.primary900())
                .padding(.bottom, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(categories) { category in
                        CategoryItemView(
                            category: category,
                            isSelected: category == selectedCategory,
                            onSelect: {
                                selectedCategory = category
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.vertical,5)
            }

            if let selectedCategory = selectedCategory {
                Text("\(selectedCategory.name):")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.blue)
                    .padding(.top, 30)
            }
        }
    }
}

#Preview {
    CategoryScroll()
}

