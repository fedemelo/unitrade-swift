//
//  TemplateView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI

struct TemplateView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    var name: String

    var body: some View {
        VStack {
            Spacer()
            Text("TODO: Implement \(name) View")
                .font(Font.DesignSystem.headline600)
            Spacer()
            Button("Log out") {
                
                loginViewModel.signOut()
            }
        }
        .padding()
    }
}
