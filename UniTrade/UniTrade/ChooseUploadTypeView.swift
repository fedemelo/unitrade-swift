//
//  UploadProductView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI

struct ChooseUploadTypeView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Select your path")
                .font(Font.DesignSystem.headline600)
                .foregroundColor(Color.DesignSystem.dark500(for: colorScheme))

            Text("Choose how you want to manage your product. You can either sell it outright or offer it for rent.")
                .font(Font.DesignSystem.bodyText300)
                .foregroundColor(Color.DesignSystem.light400(for: colorScheme))

            HStack(spacing: 16) {
                NavigationLink(destination: UploadProductView(strategy: SaleProductUploadStrategy())) {
                    ButtonWithIcon(text: "SELL", icon: "dollarsign.circle")
                }

                Spacer()

                NavigationLink(destination: UploadProductView(strategy: LeaseProductUploadStrategy())) {
                    ButtonWithIcon(text: "LIST FOR RENT", icon: "arrow.2.circlepath.circle")
                }
            }
            .frame(maxWidth: .infinity)

            Spacer()
        }
        .padding()
        .padding(.horizontal)
        .navigationTitle("Upload Product")
        .navigationBarTitleDisplayMode(.inline)
    }
}
