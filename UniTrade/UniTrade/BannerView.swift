//
//  BannerView.swift
//  UniTrade
//
//  Created by Mariana on 2/12/24.
//


import SwiftUI

struct BannerView: View {
    let message: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Spacer() // Push the banner to the bottom
            Text(message)
                .font(Font.DesignSystem.bodyText200)
                .foregroundColor(Color.DesignSystem.dark900(for: colorScheme))
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity)
                .background(Color.DesignSystem.light100(for: colorScheme))
        }
        .animation(.easeInOut, value: message)
        .transition(.move(edge: .bottom))
    }
}
