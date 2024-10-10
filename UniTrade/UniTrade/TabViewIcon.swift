//
//  TabViewIcon.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 25/09/24.
//

import SwiftUI

struct TabViewIcon: View {
    let title: String
    let unselectedIcon: String
    let selectedIcon: String
    let isSelected: Bool

    var body: some View {
        Label(title, systemImage: isSelected ? selectedIcon : unselectedIcon)
            .environment(\.symbolVariants, .none)
    }
}

