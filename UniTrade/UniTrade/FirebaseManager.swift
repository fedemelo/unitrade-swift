//
//  FirebaseManager.swift
//  UniTrade
//
//  Created by Mariana Ruiz Giraldo on 1/10/24.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAuth

class FirebaseManager {
    static let shared = FirebaseManager()

    private init() {
        FirebaseApp.configure()
    }

    func signInWithMicrosoft(){

        let provider = OAuthProvider(providerID: "microsoft.com")

        provider.getCredentialWith(nil) { credential, error in
                    if error != nil {
                        print("An error occured getting credentials: \(error!.localizedDescription)")
                        
                        return
                    }
                    if let credential = credential {
                        Auth.auth().signIn(with: credential) { _, error in
                            if error != nil {
                                print("an error occured signing in: \(error!.localizedDescription)")
                                return
                            }
                        }
                    }
                }

    }
}
