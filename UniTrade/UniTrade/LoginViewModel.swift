//
//  LoginViewModel.swift
//  UniTrade
//
//  Created by Mariana Ruiz Giraldo on 2/10/24.
//


import FirebaseAuth
import FirebaseFirestore
import SwiftUI

final class LoginViewModel: ObservableObject {
    let db = Firestore.firestore()
    @Published var firstTimeUser = true
    @Published var registeredUser : FirebaseAuth.User?
    
    var user: FirebaseAuth.User? {
            didSet {
                objectWillChange.send()
            }
        }
    var provider = OAuthProvider(providerID: "microsoft.com")
    
    func signIn(
    ) {
        self.provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                print("An error occured getting credentials")
                return
            }
            if let credential = credential {
                FirebaseAuthManager.shared.auth.signIn(with: credential) { _, error in
                    if error != nil {
                        print("An error occured signing in")
                        return
                    }
                    self.registeredUser = FirebaseAuthManager.shared.auth.currentUser
                }
                
            }
        }
    }
    
    func signOut() {
            do {
                try FirebaseAuthManager.shared.auth.signOut()
                self.registeredUser = nil
            } catch {
                print("Error signing out")
            }
        }
    
    func isFirstTimeUser() {
            let key = self.user?.uid
            if key != nil {
                let docRef = self.db.collection("Users").document(key!)
                docRef.getDocument { document, _ in
                    if let document = document, document.exists {
                        // Additional action if it is not the first time
                    } else {
                        self.firstTimeUser = true
                        self.registerUser()
                    }
                    
                }
            } else {
                print("No key was found for user")
            }
        }
    
    func registerUser() {
            if let user = self.user {
                if !self.firstTimeUser {
                    let docRef = self.db.collection("Users").document(user.uid)

                    docRef.getDocument{ document, error in
                        if let error = error as NSError? {
                        } else {
                            if let document = document {
                                do {
                                    //self.registeredUser = try document.data(as: User.self)
                                } catch {
                                    print("Error while enconding registered User \(error)")
                                }
                            }
                        }
                    }
                }
            }
        }



}
