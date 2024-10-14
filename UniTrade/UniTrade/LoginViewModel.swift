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
    @Published var categories: [CategoryName] = []
        
        init() {
            fetchCategories()
        }
        
        func fetchCategories() {
            let docRef = db.collection("categories").document("all")
            docRef.getDocument { (document, error) in
                        if let error = error {
                            print("Error fetching categories: \(error.localizedDescription)")
                            return
                        }
                        
                        if let document = document, document.exists {
                            if let categoryNames = document.data()?["names"] as? [String] {
                                self.categories = categoryNames.map { CategoryName(name: $0) }
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
    
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
                    }
                    
                }
            } else {
                print("No key was found for user")
            }
        }
    
    func registerUser(categories: Set<CategoryName>) {
        if let user = self.registeredUser {
                if self.firstTimeUser {
                    let docRef = self.db.collection("users").document(user.uid)

                    docRef.getDocument{ document, error in
                        if let error = error as NSError? {
                            print("Error while getting document \(error)")
                        } else {
                            if let _ = document {
                                do {
                                    let categoryNames = categories.map(\.name)
                                    let userModel = User(name: user.displayName!, email: user.email!, categories: categoryNames)
                                    try docRef.setData(from: userModel)
                                    self.firstTimeUser = false
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
