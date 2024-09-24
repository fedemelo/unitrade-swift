//
//  BottomMenu.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI

struct BottomMenu: View {
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                // TODO: Go home
            }) {
                VStack {
                    Image(systemName: "house")
                }
            }
            Spacer()
            Button(action: {
                // TODO: Go to cart
            }) {
                VStack {
                    Image(systemName: "cart")
                }
            }
            Spacer()
            Button(action: {
                // TODO: Add listing
            }) {
                VStack {
                    Image(systemName: "plus.circle")
                }
            }
            Spacer()
            Button(action: {
                // TODO: Notifications
            }) {
                VStack {
                    Image(systemName: "bell")
                }
            }
            Spacer()
            Button(action: {
                // TODO: Profile
            }) {
                VStack {
                    Image(systemName: "person")
                }
            }
            Spacer()
        }
        .padding(10)
        .background(Color(UIColor.systemGray6))
    }
}
