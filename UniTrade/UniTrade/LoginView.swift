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
            Image("Logo Dark Mode")
                .resizable()
                .frame(width: 300, height: 300)
            
            Text("UniTrade")
                .font(Font.DesignSystem.headline800)
                .foregroundColor(Color.white)
                Text("Get all the materials for your classes without feeling that you’re paying too much.")
                .font(Font.DesignSystem.bodyText300)
                .foregroundColor(Color.white)
                .padding(.horizontal, 40)
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
                        .foregroundColor(Color.accentColor)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding(.horizontal, 50)
            
            Spacer()
        }
        .background(Color.DesignSystem.primary900(for: colorScheme))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var vm = LoginViewModel()
    
    static var previews: some View {
        LoginView(loginViewModel: vm)
    }
}


<<<<<<< HEAD
=======

>>>>>>> develop
