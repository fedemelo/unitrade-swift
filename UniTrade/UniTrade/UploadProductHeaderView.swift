//
//  UploadProductHeaderView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 19/11/24.
//


import SwiftUI

struct UploadProductHeaderView: View {
    let viewModel: UploadProductViewModel
    let colorScheme: ColorScheme

    var body: some View {
        HStack {
            Text(viewModel.strategy.title)
                .font(Font.DesignSystem.headline600)
                .foregroundColor(Color.DesignSystem.dark500(for: colorScheme))
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
