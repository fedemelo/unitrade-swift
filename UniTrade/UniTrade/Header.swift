//
//  Header.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI

struct Header: View {
    var title: String
    var onBack: () -> Void

    var body: some View {
        VStack {
            HStack {
                
                Button(action: onBack) {
                    LeftArrow(color: Color.DesignSystem.dark900)
                }
                .padding(.leading, 16)
                Spacer()

                Text(title)
                    .foregroundColor(Color.DesignSystem.dark500Default)
                    .font(Font.DesignSystem.headline500)

                Spacer()
                // Another identical but hidden arrow for symmetry
                LeftArrow(color: .clear).padding(.leading, 16)
            }
            .padding()

            Divider()
                .background(Color.gray.opacity(0.3))
                .frame(height: 1)
        }
    }
}


struct LeftArrow: View {
    var color: Color
    
    var body: some View {
        Image(systemName: "arrow.left")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            .foregroundColor(color)
    }
}
