//
//  MyListingsViewModel.swift
//  UniTrade
//
//  Created by Santiago Martinez on 4/11/24.
//


import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class MyListingsViewModel: ObservableObject {
    @Published var userProducts: [UserProduct] = []
    @Published var isLoading: Bool = false
    private let firestore = Firestore.firestore()
    
    func loadUserProducts() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            isLoading = false
            return
        }
        
        isLoading = true
        print("USER ID: \(userId)")
        
        firestore.collection("products")
            .whereField("user_id", isEqualTo: userId)
            .getDocuments(source: .default) { snapshot, error in
                if let error = error {
                    print("Error fetching user products: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    return
                }
                
                // Check if the snapshot contains any documents
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("No products found for user with ID \(userId)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    return
                }
                
                print("Successfully fetched user products from Firestore")
                print("Number of documents fetched: \(documents.count)")
                
                // Map documents to UserProduct objects
                self.userProducts = documents.compactMap { doc -> UserProduct? in
                    guard let title = doc["name"] as? String,
                          let priceString = doc["price"] as? String,
                          let price = Float(priceString),
                          let type = doc["type"] as? String else {
                        print("⚠️ Document \(doc.documentID) missing required fields")
                        return nil
                    }
                    
                    // Default to 0 if fields are missing or cannot be cast
                    let favoritesCategory = doc["favorites_category"] as? Int ?? 0
                    let favoritesForYou = doc["favorites_foryou"] as? Int ?? 0
                    
                    // Default to an empty string if imageUrl is missing or cannot be cast
                    let imageUrl = (doc["image_url"] as? String) ?? "dummy"

                    // Calculate the save count
                    let saveCount = doc["favorites"] as? Int ?? 0
                    
                    return UserProduct(
                        id: doc.documentID,
                        title: title,
                        price: price,
                        favoritesCategory: favoritesCategory,
                        favoritesForYou: favoritesForYou,
                        imageUrl: imageUrl,
                        type: type,
                        saveCount: saveCount
                    )
                }
                    
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
    }

}
