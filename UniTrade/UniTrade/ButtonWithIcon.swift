//
//  IconButton.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI
import DesignSystem

struct ButtonWithIcon: View {
    @Environment(\.colorScheme) var colorScheme
    
    let text: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(text)
        }
        .padding(.vertical, 17)
        .padding(.horizontal, 22)
        .background(Color.DesignSystem.primary900(for: colorScheme))
        .font(Font.DesignSystem.headline500)
        .foregroundColor(.white)
        .cornerRadius(100)
    }
}
