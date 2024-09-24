//
//  MainView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI

struct MainView: View {
    @State private var selectedScreen: BottomMenuScreenEnum = .home

    var body: some View {
        NavigationStack {
            VStack {
                switch selectedScreen {
                    case .home:
                        TemplateView(name: "Home")
                    case .cart:
                        TemplateView(name: "Cart")
                    case .uploadProduct:
                        UploadProductView(onBack: {
                            selectedScreen = .home
                        })
                    case .notifications:
                        TemplateView(name: "Notifications")
                    case .profile:
                        TemplateView(name: "Profile")
                }

                Spacer()

                BottomMenu(onMenuSelected: { screen in
                    selectedScreen = screen
                })
            }
        }
    }
}

#Preview {
    MainView()
}
