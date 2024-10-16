//
//  LoginView.swift
//  UniTrade
//
//  Created by Mariana Ruiz Giraldo on 1/10/24.
//


import SwiftUI

struct LoginView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image("Image Auth")
                .resizable()
                .frame(width: 300, height: 300)
            
            Text("Discover the best offers")
                .padding(.horizontal, 40)
                .font(Font.DesignSystem.headline800)
                .foregroundColor(Color.accentColor)
                .multilineTextAlignment(.center)
            
            Text("Get all the materials for your classes without feeling that you’re paying too much.")
                .font(Font.DesignSystem.bodyText300)
                .foregroundColor(Color.DesignSystem.dark800())
                .padding(.horizontal, 30)
                .multilineTextAlignment(.center)
                
            
            Spacer()
            
            Button(action: {
                loginViewModel.signIn()
            }) {
                HStack {
                    Image("Logo Microsoft")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Login with Microsoft")
                        .font(Font.DesignSystem.headline500)
                        .foregroundColor(Color.white)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(Color.accentColor)
                .background(Color.accentColor)
                .cornerRadius(25)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .background(Color.white)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var vm = LoginViewModel()
    
    static var previews: some View {
        LoginView(loginViewModel: vm)
    }
}



