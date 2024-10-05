//
//  FirebaseAuthManager.swift
//  UniTrade
//
//  Created by Mariana Ruiz Giraldo on 2/10/24.
//


import FirebaseAuth

final class FirebaseAuthManager {
    // Singleton instance
    static let shared = FirebaseAuthManager()

    // Private initializer to prevent external instances
    private init() {}

    // Firebase Auth instance
    let auth = Auth.auth()
}
