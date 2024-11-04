//
//  UserProductItemView.swift
//  UniTrade
//
//  Created by Santiago Martinez on 4/11/24.
//


import SwiftUI

struct UserProductItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: UserProductViewModel

    var body: some View {
        HStack(spacing: 15) {
            // Product Image
            ZStack {
                if let imageUrl = viewModel.imageUrl, !imageUrl.isEmpty {
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .foregroundColor(Color.DesignSystem.light200(for: colorScheme))
                                .overlay(ProgressView())
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        case .failure:
                            Rectangle()
                                .foregroundColor(.gray)
                                .overlay(Image(systemName: "photo").foregroundColor(.white))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Rectangle()
                        .foregroundColor(Color.DesignSystem.light200(for: colorScheme))
                        .overlay(Image(systemName: "photo").foregroundColor(.white))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .frame(width: 80, height: 80)
            
            // Product details (title, price, type)
            VStack(alignment: .leading, spacing: 5) {
                // Product title
                Text(viewModel.title)
                    .font(Font.DesignSystem.headline400)
                    .lineLimit(1)
                    .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.DesignSystem.primary600())
                
                // Product price
                Text(viewModel.formattedPrice)
                    .font(Font.DesignSystem.bodyText200)
                    .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.DesignSystem.primary600())
                
                // Product type (e.g., "For Sale")
                Text(viewModel.type)
                    .font(Font.DesignSystem.bodyText200)
                    .foregroundColor(Color.DesignSystem.secondary900(for: colorScheme))
            }
            
            Spacer()
            
            // Save count
            VStack(alignment: .trailing) {
                Text("\(viewModel.saveCount)")
                    .font(Font.DesignSystem.headline800)
                    .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.DesignSystem.primary600())
                Text("Saves")
                    .font(Font.DesignSystem.bodyText200)
                    .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.DesignSystem.primary600())
            }
        }
        .padding()
        .background(Color.DesignSystem.whitee(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}
