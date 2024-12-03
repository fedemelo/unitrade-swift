//
//  MyFavoritesViewModel.swift
//  UniTrade
//
//  Created by Santiago Martinez on 2/12/24.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

class MyFavoritesViewModel: ObservableObject {
    @Published var favoriteProducts: [Product] = []
    private let firestore = Firestore.firestore()
    
    func loadFavorites(completion: @escaping (Bool, String?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("⚠️ User is not authenticated.")
            completion(false, "User is not authenticated.")
            return
        }
        
        
        // Fetch the user's favorite product IDs
        let userDocRef = firestore.collection("users").document(userId)
        userDocRef.getDocument { [weak self] document, error in
            if let error = error {
                print("❌ Error fetching user document: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
                return
            }
            
            guard let data = document?.data() else {
                completion(false, "No favorites found for this user.")
                return
            }
            
            guard let favoriteProductIds = data["favorites"] as? [String] else {
                completion(false, "No favorites found for this user.")
                return
            }
            
            
            // Fetch product details for each favorite ID
            self?.fetchProducts(for: favoriteProductIds, completion: completion)
        }
    }
    
    private func fetchProducts(for productIds: [String], completion: @escaping (Bool, String?) -> Void) {
        guard !productIds.isEmpty else {
            DispatchQueue.main.async {
                self.favoriteProducts = []
                completion(true, nil)
            }
            return
        }
        
        firestore.collection("products")
            .whereField(FieldPath.documentID(), in: productIds)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(false, "No products found.")
                    return
                }
                
                let products = documents.compactMap { doc -> Product? in
                    guard let name = doc["name"] as? String,
                          let priceString = doc["price"] as? String,
                          let price = Float(priceString),
                          let categoriesArray = doc["categories"] as? [String],
                          let type = doc["type"] as? String else {
                        return nil
                    }
                    
                    let rating = (doc["rating"] as? NSNumber)?.floatValue ?? 0.0
                    let reviewCount = (doc["review_count"] as? NSNumber)?.intValue ?? 0
                    let condition = doc["condition"] as? String ?? "New"
                    let description = doc["description"] as? String ?? "No description available"
                    let imageUrl = doc["image_url"] as? String ?? "dummy"
                    let inStock = doc["in_stock"] as? Bool ?? true
                    let favorites = doc["favorites"] as? Int ?? 0
                    let favoritesCategory = doc["favorites_category"] as? Int ?? 0
                    let favoritesForYou = doc["favorites_foryou"] as? Int ?? 0
                    
                    guard inStock else {
                        return nil
                    }
                    
                    return Product(
                        id: doc.documentID,
                        title: name,
                        price: price,
                        rating: rating,
                        condition: condition,
                        description: description,
                        reviewCount: reviewCount,
                        type: type,
                        inStock: inStock,
                        categories: categoriesArray.joined(separator: ", "),
                        imageUrl: imageUrl,
                        isFavorite: true,
                        favorites: favorites,
                        favoritesCategory: favoritesCategory,
                        favoritesForYou: favoritesForYou
                    )
                }
                
                DispatchQueue.main.async {
                    self?.favoriteProducts = products
                    completion(true, nil)
                }
            }
    }
    
    
    func toggleFavorite(productId: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        
        if let index = favoriteProducts.firstIndex(where: { $0.id == productId }) {
            favoriteProducts[index].isFavorite.toggle()
            let isNowFavorite = favoriteProducts[index].isFavorite
            print("✅ Product \(favoriteProducts[index].title) is now \(isNowFavorite ? "favorited" : "unfavorited")")
            
            let userDocRef = firestore.collection("users").document(userId)
            userDocRef.getDocument { document, error in
                if let error = error {
                    print("❌ Error fetching user document: \(error.localizedDescription)")
                    // Revert the local change if the update fails
                    DispatchQueue.main.async {
                        self.favoriteProducts[index].isFavorite.toggle()
                    }
                    return
                }
                
                guard let data = document?.data(),
                      var favorites = data["favorites"] as? [String] else {
                    print("⚠️ Unable to fetch or parse the 'favorites' array.")
                    // Revert the local change if the update fails
                    DispatchQueue.main.async {
                        self.favoriteProducts[index].isFavorite.toggle()
                    }
                    return
                }
                
                if isNowFavorite {
                    // Add to favorites
                    favorites.append(productId)
                } else {
                    // Remove from favorites
                    favorites.removeAll { $0 == productId }
                }
                
                print("ℹ️ Updating 'favorites' field in Firestore: \(favorites)")
                
                // Update the Firestore document
                userDocRef.updateData(["favorites": favorites]) { error in
                    if let error = error {
                        print("❌ Error updating 'favorites' in Firestore: \(error.localizedDescription)")
                        // Revert the local change if the update fails
                        DispatchQueue.main.async {
                            self.favoriteProducts[index].isFavorite.toggle()
                        }
                    } else {
                        print("✅ Successfully updated 'favorites' in Firestore.")
                        // Remove the product from the list if unfavorited
                        if !isNowFavorite {
                            DispatchQueue.main.async {
                                self.favoriteProducts.remove(at: index)
                            }
                        }
                    }
                }
            }
        } else {
            print("⚠️ Product with ID \(productId) not found in favoriteProducts.")
        }
    }
    
}
