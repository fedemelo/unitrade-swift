//
//  UploadProductView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI

struct UploadProductView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 30) {
                Text("Select your path")
                    .font(Font.DesignSystem.headline600)
                    .foregroundColor(Color.DesignSystem.dark500Default)
                
                Text("Choose how you want to manage your product. You can either sell it outright or offer it for rent.")
                    .font(Font.DesignSystem.bodyText300)
                    .foregroundColor(Color.DesignSystem.light400)
                
                HStack(spacing: 16) {
                    NavigationLink(destination: UploadSelling()) {
                        IconButton(text: "SELL", icon: "dollarsign.circle")
                    }
                    
                    Spacer()

                    NavigationLink(destination: UploadRenting()) {
                        IconButton(text: "LIST FOR RENT", icon: "arrow.2.circlepath.circle")
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding()
            .padding(.horizontal)
            
        }
        .navigationTitle("Upload Product")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Upload Product")
                    .foregroundColor(Color.DesignSystem.dark500Default)
                    .font(Font.DesignSystem.headline500)
            }
        }
    }
}
