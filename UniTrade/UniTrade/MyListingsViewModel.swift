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

                // Map documents to UserProduct objects
                self.userProducts = snapshot?.documents.compactMap { doc -> UserProduct? in
                    guard let title = doc["title"] as? String,
                          let priceString = doc["price"] as? String,
                          let price = Float(priceString),
                          let favoritesCategory = doc["favorites_category"] as? Int,
                          let favoritesForYou = doc["favorites_foryou"] as? Int,
                          let imageUrl = doc["image_url"] as? String,
                          let type = doc["type"] as? String else {
                        return nil
                    }
                    
                    return UserProduct(
                        id: doc.documentID,
                        title: title,
                        price: price,
                        favoritesCategory: favoritesCategory,
                        favoritesForYou: favoritesForYou,
                        imageUrl: imageUrl,
                        type: type
                    )
                } ?? []
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
    }
}
