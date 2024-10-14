//
//  SortButton.swift
//  UniTrade
//
//  Created by Santiago Martinez on 1/10/24.
//

import SwiftUI

struct SortButton: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            Text(title)
                .font(.headline)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .foregroundColor(isSelected ? Color.white : Color.blue)
                .background(isSelected ? Color.blue : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue, lineWidth: 1)
                )
                .cornerRadius(20)
        }
    }
}
