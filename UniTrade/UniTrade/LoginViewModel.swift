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
    
    func signIn() {
        self.provider.customParameters = ["prompt": "select_account"]
        self.provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                print("An error occurred getting credentials")
                return
            }
            if let credential = credential {
                FirebaseAuthManager.shared.auth.signIn(with: credential) { result, error in
                    if error != nil {
                        print("An error occurred signing in")
                        return
                    }
                    self.registeredUser = FirebaseAuthManager.shared.auth.currentUser
                    if let user = self.registeredUser {
                        self.logSignInStats(for: user)
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            try FirebaseAuthManager.shared.auth.signOut()
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            registeredUser = nil
        } catch {
            print("Error signing out")
        }
    }
    
    func logSignInStats(for user: FirebaseAuth.User) {
        let currentDate = Date()
        let calendar = Calendar.current

        // Obtener la hora y el día de la semana
        let hour = calendar.component(.hour, from: currentDate)  // 0 to 23
        let weekday = calendar.component(.weekday, from: currentDate) - 1  // 0 to 6 (0 = Sunday)

        // Referencia al documento "time_engagement" en la colección "analytics"
        let statsRef = db.collection("analytics").document("time_engagement")

        // Campo que representa el contador para la hora actual y día de la semana
        let fieldPath = "day_\(weekday).hour_\(hour)"

        // Incrementar el contador de inicio de sesión para la hora y día actuales
        statsRef.updateData([fieldPath: FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating sign-in stats: \(error)")
            } else {
                print("Successfully updated sign-in stats")
            }
        }
    }

    func isFirstTimeUser() {
        print("Checking if user is first time")
        let key = self.user?.uid
        if key != nil {
            let docRef = self.db.collection("users").document(key!)
            docRef.getDocument { document, _ in
                if let document = document, document.exists {
                    print("User already exists")
                } else {
                    self.firstTimeUser = true
                    print("User is first time")
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
                
                docRef.getDocument { document, error in
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
                                print("Error while encoding registered User \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
}
