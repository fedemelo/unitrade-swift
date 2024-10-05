//
//  FirstTimeUserView.swift
//  UniTrade
//
//  Created by Mariana Ruiz Giraldo on 2/10/24.
//


import FirebaseAuth
import SwiftUI

struct FirstTimeUserView: View {
    
    var user: FirebaseAuth.User?
    @ObservedObject var loginVM: LoginViewModel

    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Welcome!")
                Text(user?.displayName ?? "Loading name...")
            }
            .font(.title)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            Spacer()
            Text("Choose your food preferences").font(.headline).multilineTextAlignment(.leading)
        }
    }
        
        struct FirstTimeUserView_Previews: PreviewProvider {
            static var previews: some View {
                FirstTimeUserView(user: Auth.auth().currentUser, loginVM: LoginViewModel())
            }
        }
    }
