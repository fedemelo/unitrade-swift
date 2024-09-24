//
//  IconButton.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI
import DesignSystem

struct IconButton: View {
    let text: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(text)
            }
            .padding(.vertical, 17)
            .padding(.horizontal, 22)
            .background(Color.DesignSystem.primary900Default)
            .font(Font.DesignSystem.headline400)
            .foregroundColor(.white)
            .cornerRadius(100)
        }
    }
}

#Preview {
    IconButton(text: "BOTONSITO", icon: "smiley", action: {})
}
