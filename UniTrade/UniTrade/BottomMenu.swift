//
//  BottomMenu.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI
import DesignSystem

struct BottomMenu: View {
    // You could have a state variable here to manage which screen is active
    @State private var selectedScreen: String = "home"
    
    var body: some View {
        HStack {
            Spacer()
            BottomMenuIcon(icon: "house") {
                // TODO: selectedScreen = "home"
            }
            Spacer()
            BottomMenuIcon(icon: "cart") {
                // TODO: selectedScreen = "cart"
            }
            Spacer()
            BottomMenuIcon(icon: "plus.circle") {
                // TODO: selectedScreen = "addListing"
            }
            Spacer()
            BottomMenuIcon(icon: "bell") {
                // TODO: selectedScreen = "notifications"
            }
            Spacer()
            BottomMenuIcon(icon: "person") {
                // TODO: selectedScreen = "profile"
            }
            Spacer()
        }
        .padding(.top, 30)
        .background(Color.DesignSystem.primary900Default)
    }
}
