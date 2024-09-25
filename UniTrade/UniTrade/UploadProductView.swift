//
//  UploadProductView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI

struct TextConstants {
    static let headerTitle = "Upload Product"
    static let contentTitle = "Select your path"
    static let explanation = "Choose how you want to manage your product. You can either sell it outright or offer it for rent."
    static let sellButtonText = "SELL"
    static let rentButtonText = "LIST FOR RENT"
}


import SwiftUI

struct UploadProductView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text(TextConstants.contentTitle)
                .font(Font.DesignSystem.headline600)
                .foregroundColor(Color.DesignSystem.dark500Default)
            
            Text(TextConstants.explanation)
                .font(Font.DesignSystem.bodyText300)
                .foregroundColor(Color.DesignSystem.light400)
            
            HStack(spacing: 16) {
                IconButton(text: TextConstants.sellButtonText,
                           icon: "dollarsign.circle") {
                    // TODO: Action for SELL
                    print("Sell button tapped")
                }
                
                Spacer()
                
                IconButton(text: TextConstants.rentButtonText,
                           icon: "arrow.2.circlepath.circle") {
                    // TODO: Action for LIST FOR RENT
                    print("List for rent button tapped")
                }
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding()
        .padding(.horizontal)
        .navigationTitle(TextConstants.headerTitle)
        .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(TextConstants.headerTitle)
                        .foregroundColor(Color.DesignSystem.dark500Default)
                        .font(Font.DesignSystem.headline500)
                }
            }
    }
}
