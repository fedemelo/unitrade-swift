//
//  ProfileViewModel.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 19/10/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var isImageFromGallery: Bool = false
    @Published var userName: String? = nil
    @Published var isSigningOut: Bool = false

    // Inject the LoginViewModel for managing sign-in and sign-out
    private let loginViewModel = LoginViewModel()

    func fetchUserName() {
        guard let user = Auth.auth().currentUser else {
            print("⚠️ User is not authenticated.")
            return
        }

        let userDocRef = Firestore.firestore().collection("users").document(user.uid)
        print("User ID", user.uid)
        userDocRef.getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                self.userName = data["name"] as? String
            } else {
                print("⚠️ User document not found or error occurred.")
            }
        }
    }

    func signOut(completion: @escaping (Bool) -> Void) {
        isSigningOut = true
        loginViewModel.signOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Simulate a delay
            self.isSigningOut = false
            let wasSignedOut = Auth.auth().currentUser == nil
            completion(wasSignedOut)
        }
    }

    func toggleTheme() {
        // Implement your theme toggle logic here.
    }
}
