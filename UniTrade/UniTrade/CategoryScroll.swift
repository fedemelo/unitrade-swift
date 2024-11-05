//
//  CategoryScroll.swift
//  UniTrade
//
//  Created by Santiago Martinez on 30/09/24.
//

import SwiftUI


struct CategoryScroll: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedCategory: String? // Binding to the selected category
    let categories: [Category]             // List of categories
    
    let bubbleWidth: CGFloat = 80   // Width of a single category bubble

    var body: some View {
        VStack(alignment: .leading) {
            Text("Categories")
                .font(Font.DesignSystem.headline600)
                .bold()
                .foregroundStyle(colorScheme == .light ? Color.DesignSystem.primary900() : Color.DesignSystem.primary600())
                .padding(.leading, 20) // Padding to align the title with the bubbles
                .padding(.bottom, 5)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack() {
                    ForEach(categories) { category in
                        CategoryItemView(
                            category: category,
                            isSelected: category.name == selectedCategory,
                            onSelect: {
                                selectedCategory = category.name
                            }
                        )
                        .frame(width: bubbleWidth) // Fixed width for each bubble
                    }
                }
                .padding(.horizontal, 25) // Padding on the left and right for screen borders
            }
            .frame(height: 150) // Adjust the height as needed

            // Display selected category if available
            if let selectedCategory = selectedCategory {
                Text("\(selectedCategory):")
                    .font(Font.DesignSystem.headline600)
                    .bold()
                    .foregroundStyle(colorScheme == .light ? Color.DesignSystem.primary900() : Color.DesignSystem.primary600())
                    .padding(.leading, 20)
                    .padding(.top, 10)
            }
        }
    }
}

