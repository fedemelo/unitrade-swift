//
//  MyOrdersViewModel.swift
//  UniTrade
//
//  Created by Mariana Ruiz on 1/12/24.
//


import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Network

class MyOrdersViewModel: ObservableObject {
    @Published var userProducts: [UserProduct] = []
    @Published var isLoading: Bool = false
    private let firestore = Firestore.firestore()
    private let localStorageKey = "userOrders" // Key for UserDefaults
    private let networkMonitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    init() {
        networkMonitor.start(queue: queue)
    }

    func loadUserProducts() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            isLoading = false
            return
        }

        isLoading = true
        print("USER ID: \(userId)")

        // Check for internet connectivity
        if networkMonitor.currentPath.status == .satisfied {
            print("Internet connection available. Fetching from Firestore.")
            fetchFromFirestore(userId: userId)
        } else {
            print("No internet connection. Fetching from local storage.")
            fetchFromLocalStorage()
        }
    }

    private func fetchFromFirestore(userId: String) {
        firestore.collection("products")
            .whereField("buyer_id", isEqualTo: userId)
            .getDocuments(source: .default) { (snapshot, error) in
                if let error = error {
                    print("Error fetching user products: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    return
                }

                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("No orders found for user with ID \(userId)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    return
                }

                print("Successfully fetched user orders from Firestore")
                print("Number of documents fetched: \(documents.count)")

                let products = documents.compactMap { doc -> UserProduct? in
                    guard let title = doc["name"] as? String,
                          let priceString = doc["price"] as? String,
                          let price = Float(priceString),
                          let purchaseDate = doc["purchase_date"] as? String else {
                        print("⚠️ Document \(doc.documentID) missing required fields")
                        return nil
                    }

                    let favoritesCategory = doc["favorites_category"] as? Int ?? 0
                    let favoritesForYou = doc["favorites_foryou"] as? Int ?? 0
                    let imageUrl = (doc["image_url"] as? String) ?? "dummy"
                    let saveCount = doc["favorites"] as? Int ?? 0
                    let type = doc["type"] as? String ?? "default"

                    return UserProduct(
                        id: doc.documentID,
                        title: title,
                        price: price,
                        favoritesCategory: favoritesCategory,
                        favoritesForYou: favoritesForYou,
                        imageUrl: imageUrl,
                        type: type,
                        saveCount: saveCount,
                        purchaseDate: purchaseDate
                    )
                }

                // Save fetched products locally
                self.saveToLocalStorage(products)

                DispatchQueue.main.async {
                    self.userProducts = products
                    self.isLoading = false
                }
            }
    }

    private func fetchFromLocalStorage() {
        if let data = UserDefaults.standard.data(forKey: localStorageKey),
           let savedProducts = try? JSONDecoder().decode([UserProduct].self, from: data) {
            DispatchQueue.main.async {
                self.userProducts = savedProducts
                self.isLoading = false
            }
        } else {
            print("No saved products in local storage.")
            DispatchQueue.main.async {
                self.userProducts = []
                self.isLoading = false
            }
        }
    }

    private func saveToLocalStorage(_ products: [UserProduct]) {
        if let data = try? JSONEncoder().encode(products) {
            UserDefaults.standard.set(data, forKey: localStorageKey)
            print("Products saved to local storage.")
        } else {
            print("Failed to save products to local storage.")
        }
    }
}
