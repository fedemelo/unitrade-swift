//
//  MainView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab: BottomMenuScreenEnum = .home
    init(
        loginViewModel: LoginViewModel
    ) {
        let appearance = UITabBarAppearance()
        
        self.loginViewModel = loginViewModel
        loginViewModel.isFirstTimeUser()
        
        appearance.backgroundColor = UIColor(Color.DesignSystem.primary900(for: colorScheme))

        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.DesignSystem.contrast900(for: colorScheme))

        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.DesignSystem.contrast900(for: colorScheme))
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.DesignSystem.contrast900(for: colorScheme))]

        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }

    let tabsNamesAndIcons:
    [(title: String, unselectedIcon: String, selectedIcon: String, tag: BottomMenuScreenEnum)] =
    [("Home", "house", "house.fill", .home),
     ("Cart", "cart", "cart.fill", .cart),
     ("Upload", "plus.circle", "plus.circle.fill", .uploadProduct),
     ("Notifications", "bell", "bell.fill", .notifications),
     ("Profile", "person", "person.fill", .profile)
    ]

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(tabsNamesAndIcons, id: \.tag) {
                tab in tabView(for: tab.tag)
                    .tabItem {
                        TabViewIcon(
                            title: tab.title,
                            unselectedIcon: tab.unselectedIcon,
                            selectedIcon: tab.selectedIcon,
                            isSelected: selectedTab == tab.tag)
                    }
                    .tag(tab.tag)
            }
        }
    }

    @ViewBuilder
    func tabView(for tag: BottomMenuScreenEnum) -> some View {
        switch tag {
        case .home:
            TemplateView(loginViewModel: loginViewModel, name: "Home")
        case .cart:
            TemplateView(loginViewModel: loginViewModel,name: "Cart")
        case .uploadProduct:
            NavigationStack {
                ChooseUploadTypeView()
            }
        case .notifications:
            TemplateView(loginViewModel: loginViewModel,name: "Notifications")
        case .profile:
            TemplateView(loginViewModel: loginViewModel,name: "Profile")
        }
    }
}

enum BottomMenuScreenEnum: Hashable {
    case home
    case cart
    case uploadProduct
    case notifications
    case profile
}

#Preview {
    MainView(loginViewModel: LoginViewModel())
}
