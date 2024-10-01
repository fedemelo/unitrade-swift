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
                .frame(width: 40, height: 40)
                .foregroundStyle(isSelected ? Color.DesignSystem.secondary900() : Color.DesignSystem.primary900())
                .padding()
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 2)
            
            Text(category.name)
                .font(.headline)
                .foregroundColor(isSelected ? Color.orange : Color.black)
            
            Text("\(category.itemCount) Items")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .onTapGesture {
            onSelect()
        }
    }
}



