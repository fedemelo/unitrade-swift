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
                    .bold()
            }
            .padding()
            .background(Color.DesignSystem.primary900Default)
            .foregroundColor(.white)
            .font(Font.DesignSystem.headline400)
            .cornerRadius(100)
        }
    }
}

#Preview {
    IconButton(text: "BOTONSITO", icon: "smiley", action: {})
}
