//
//  CategoryItemView.swift
//  UniTrade
//
//  Created by Santiago Martinez on 30/09/24.
//

import SwiftUI


struct CategoryItemView: View {
    let category: Category
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        VStack {
            Image(systemName: category.systemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .foregroundStyle(Color.DesignSystem.light100())
                .padding()
                .background(isSelected ? Color.DesignSystem.secondary900() : Color.DesignSystem.primary600())
                .clipShape(Circle())
            
            Text(category.name)
                .font(Font.DesignSystem.bodyText200)
                .foregroundStyle(isSelected ? Color.DesignSystem.secondary900() : Color.DesignSystem.dark900())
            
            Text("\(category.itemCount) Items")
                .font(Font.DesignSystem.bodyText100)
                .foregroundColor(.gray)
        }
        .onTapGesture {
            onSelect()
        }
    }
}



