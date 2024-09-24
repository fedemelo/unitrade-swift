//
//  BottomMenu.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI
import DesignSystem

struct BottomMenu: View {
    var onMenuSelected: (BottomMenuScreenEnum) -> Void

    var body: some View {
        HStack {
            Spacer()
            BottomMenuIcon(icon: "house") {
                onMenuSelected(.home)
            }
            Spacer()
            BottomMenuIcon(icon: "cart") {
                onMenuSelected(.cart)
            }
            Spacer()
            BottomMenuIcon(icon: "plus.circle") {
                onMenuSelected(.uploadProduct)
            }
            Spacer()
            BottomMenuIcon(icon: "bell") {
                onMenuSelected(.notifications)
            }
            Spacer()
            BottomMenuIcon(icon: "person") {
                onMenuSelected(.profile)
            }
            Spacer()
        }
        .padding(.top, 30)
        .background(Color.DesignSystem.primary900Default)
    }
}


enum BottomMenuScreenEnum: Hashable {
    case home
    case cart
    case uploadProduct
    case notifications
    case profile
}
