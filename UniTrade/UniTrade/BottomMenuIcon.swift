//
//  BottomMenuIcon.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI
import DesignSystem

struct BottomMenuIcon: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .foregroundColor(Color.DesignSystem.contrast900Default)
            }
        }
        
    }
}
