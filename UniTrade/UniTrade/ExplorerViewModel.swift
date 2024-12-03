import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth
import Network

class ExplorerViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var searchQuery: String = ""
    @Published var selectedCategory: String? = nil {
        didSet {
            if let category = selectedCategory {
                print("🛑 Category selected: \(category)")
                trackCategoryClick(category: category)  // Track the category click
            }
        }
    }
    @Published var activeFilter = Filter()
    @Published var isDataLoaded = false
    @Published var forYouCategories: [String] = []  // Holds "For You" categories
    @Published var isConnected: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    private let firestore = Firestore.firestore()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    func reloadProducts() {
        print("🔄 Reloading products...")
        loadProductsFromFirestore()
    }
    
    init() {
        setupNetworkMonitor()
        loadForYouCategories { [weak self] success in
            if success {
                print("✅ 'For You' categories loaded successfully.")
                self?.selectedCategory = ProductCategoryGroupManager.Groups.foryou
            } else {
                print("⚠️ Failed to load 'For You' categories.")
            }
        }
    }
    
    private func setupNetworkMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.loadForYouCategories { success in
                    if success {
                        print("✅ Loaded 'For You' categories based on network status.")
                    }
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func loadForYouCategories(completion: @escaping (Bool) -> Void) {
        if isConnected {
            // Fetch categories from Firestore if online
            guard let user = Auth.auth().currentUser else {
                print("⚠️ User is not authenticated.")
                completion(false)
                return
            }
            
            let userDocRef = firestore.collection("users").document(user.uid)
            userDocRef.getDocument { [weak self] document, error in
                if let error = error {
                    print("❌ Error fetching user data: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let data = document?.data(),
                      let categories = data["categories"] as? [String] else {
                    print("⚠️ No 'For You' categories found for user with id", user.uid)
                    completion(false)
                    return
                }
                
                DispatchQueue.main.async {
                    self?.forYouCategories = categories
                    UserDefaults.standard.set(categories, forKey: "userCategories") // Save to UserDefaults
                    completion(true)
                }
            }
        } else {
            // Fetch categories from UserDefaults if offline
            if let savedCategories = UserDefaults.standard.stringArray(forKey: "userCategories") {
                forYouCategories = savedCategories
                completion(true)
            } else {
                print("⚠️ No User categories found in UserDefaults.")
                completion(false)
            }
        }
    }
    
    private func applyFilters() {
        guard isDataLoaded else {
            print("⚠️ Attempted to apply filters, but data is not loaded yet.")
            return
        }
        objectWillChange.send()
    }
    
    var filteredProducts: [Product] {
        guard isDataLoaded else { return [] }
        
        var filtered = products.filter { $0.inStock ?? true}
        
        if let selectedCategory = selectedCategory {
            
            let categoryTags = getCategories(for: selectedCategory)
            if let tags = categoryTags {
                filtered = filtered.filter { product in
                    let productCategories = product.categories
                        .components(separatedBy: ",")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() }
                    
                    return productCategories.contains { tags.contains($0.uppercased()) }
                }
            }
        }
        
        if !searchQuery.isEmpty {
            filtered = filtered.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }
        }
        
        if let minPrice = activeFilter.minPrice, let maxPrice = activeFilter.maxPrice {
            filtered = filtered.filter { product in
                let price = Double(product.price)
                return (minPrice == 0 || price >= minPrice) &&
                (maxPrice == 0 || price <= maxPrice)
            }
        }
        if let sortOption = activeFilter.sortOption {
            switch sortOption {
            case "Price":
                filtered = activeFilter.isAscending ?
                filtered.sorted { $0.price < $1.price } :
                filtered.sorted { $0.price > $1.price }
            case "Rating":
                filtered = activeFilter.isAscending ?
                filtered.sorted { $0.rating < $1.rating } :
                filtered.sorted { $0.rating > $1.rating }
            default:
                break
            }
        }
        return filtered
    }
    
    private func getCategories(for group: String) -> [String]? {
        if group == ProductCategoryGroupManager.Groups.foryou {
            return forYouCategories.isEmpty ? nil : forYouCategories
        }
        return ProductCategoryGroupManager.productGroups[group]
    }
    
    private func updateFavoriteInFirestore(for product: Product) {
        let productRef = firestore.collection("products").document(product.id.lowercased())
        
        // Determine the increment value based on the favorite status
        let incrementValue: Int64 = product.isFavorite ? 1 : 0
        let changeValue: Int64 = product.isFavorite ? 1 : -1
        
        // Prepare the updates dictionary with dynamic increment
        var updates: [String: FieldValue] = [
            "favorites": FieldValue.increment(changeValue)
        ]
        
        if selectedCategory == "For You" {
            updates["favorites_foryou"] = FieldValue.increment(incrementValue)
            print("🔄 \(incrementValue > 0 ? "Incrementing" : "Decrementing") favorites_foryou for product: \(product.title)")
        } else if selectedCategory != nil {
            updates["favorites_category"] = FieldValue.increment(incrementValue)
            print("🔄 \(incrementValue > 0 ? "Incrementing" : "Decrementing") favorites_category for product: \(product.title)")
        }
        
        // Perform the update
        productRef.updateData(updates) { error in
            if let error = error {
                print("❌ Error updating favorite counts in Firestore: \(error.localizedDescription)")
            } else {
                print("✅ Successfully updated favorite counts in Firestore for \(product.title)")
            }
        }
    }
    
    func loadProductsFromFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("⚠️ User is not authenticated.")
            return
        }
        
        print("📦 Fetching products from Firestore...")
        
        // Step 1: Fetch the user's favorite products
        let userDocRef = firestore.collection("users").document(userId)
        userDocRef.getDocument { [weak self] document, error in
            if let error = error {
                print("❌ Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let data = document?.data(),
                  let favoriteProductIds = data["favorites"] as? [String] else {
                print("⚠️ No favorites found for this user.")
                self?.fetchAndMarkProducts(favoriteProductIds: [])
                return
            }
            
            print("ℹ️ User's favorite product IDs: \(favoriteProductIds)")
            self?.fetchAndMarkProducts(favoriteProductIds: favoriteProductIds)
        }
    }
    
    // Step 2: Fetch products and mark favorites
    private func fetchAndMarkProducts(favoriteProductIds: [String]) {
        firestore.collection("products").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("❌ Error fetching products: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("⚠️ No products found.")
                return
            }
            
            let fetchedProducts = documents.compactMap { doc -> Product? in
                let productID = doc.documentID
                guard let name = doc["name"] as? String,
                      let priceString = doc["price"] as? String,
                      let price = Float(priceString),
                      let categoriesArray = doc["categories"] as? [String],
                      let type = doc["type"] as? String else {
                    print("⚠️ Invalid data in document \(doc.documentID)")
                    return nil
                }
                
                let inStock = (doc["in_stock"] as? Bool) ?? true
                let condition = (doc["condition"] as? String) ?? "New"
                let description = (doc["description"] as? String) ?? "No description available"
                let reviewCount = (doc["review_count"] as? NSNumber)?.intValue ?? 0
                let rating = (doc["rating"] as? NSNumber)?.floatValue ?? 0.0
                let imageUrl = (doc["image_url"] as? String) ?? "dummy"
                let categories = categoriesArray.joined(separator: ", ")
                let favorites = (doc["favorites"] as? NSNumber)?.intValue ?? 0
                let favoritesCategory = (doc["favorites_category"] as? NSNumber)?.intValue ?? 0
                let favoritesForYou = (doc["favorites_foryou"] as? NSNumber)?.intValue ?? 0
                
                // Check if the product is in the favorites array
                let isFavorite = favoriteProductIds.contains(productID)
                
                return Product(
                    id: productID,
                    title: name,
                    price: price,
                    rating: rating,
                    condition: condition,
                    description: description,
                    reviewCount: reviewCount,
                    type: type,
                    inStock: inStock,
                    categories: categories,
                    imageUrl: imageUrl,
                    isFavorite: isFavorite, // Mark as favorite
                    favorites: favorites,
                    favoritesCategory: favoritesCategory,
                    favoritesForYou: favoritesForYou
                )
            }
            
            DispatchQueue.main.async {
                self?.products = fetchedProducts
                self?.isDataLoaded = true
                print("✅ Products loaded and marked favorites: \(self?.products.count ?? 0)")
                self?.applyFilters()
            }
        }
    }
    // Fetch the initial data in a background queue
    func fetchInitialDataInBackground() {
        DispatchQueue.global(qos: .userInitiated).async {
            // Load "For You" categories first
            self.loadForYouCategories { success in
                if success {
                    print("✅ 'For You' categories loaded in background.")
                    self.selectedCategory = ProductCategoryGroupManager.Groups.foryou
                } else {
                    print("⚠️ Failed to load 'For You' categories.")
                }
                
                // Load products asynchronously
                self.loadProductsFromFirestore()
                self.isDataLoaded = true
                print("✅ Products loaded in background.")
            }
        }
    }
    
    func fetchFavoritesInBackground() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("⚠️ User is not logged in. Cannot fetch favorites.")
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchFavoriteProductIds(for: userId)
        }
    }
    
    // MARK: - Fetch Favorites
    private func fetchFavoriteProductIds(for userId: String) {
        print("🔍 Fetching favorite product IDs for user: \(userId)")
        let userDocRef = firestore.collection("users").document(userId)
        userDocRef.getDocument { [weak self] document, error in
            if let error = error {
                print("❌ Error fetching user favorites: \(error.localizedDescription)")
                return
            }
            
            guard let data = document?.data(),
                  let favoriteProductIds = data["favorites"] as? [String] else {
                print("⚠️ No favorites found for user \(userId).")
                return
            }
            print("✅ Favorite products successfully fetched in background.")
            print("ℹ️ Favorite product IDs: \(favoriteProductIds)")
            self?.markFavorites(for: favoriteProductIds)
        }
    }
    
    // MARK: - Mark Favorites
    private func markFavorites(for favoriteProductIds: [String]) {
        DispatchQueue.main.async {
            for (index, product) in self.products.enumerated() {
                if favoriteProductIds.contains(product.id) {
                    self.products[index].isFavorite = true
                }
            }
            print("✅ Marked favorite products.")
        }
    }
    
    func toggleFavorite(for productID: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("⚠️ User is not authenticated.")
            return
        }
        
        print("🔄 Toggling favorite for product ID: \(productID)")
        
        if let index = products.firstIndex(where: { $0.id == productID }) {
            // Toggle local state
            products[index].isFavorite.toggle()
            let isNowFavorite = products[index].isFavorite
            print("✅ Product \(products[index].title) is now \(isNowFavorite ? "favorited" : "unfavorited")")
            
            let userDocRef = firestore.collection("users").document(userId)
            userDocRef.getDocument { document, error in
                if let error = error {
                    print("❌ Error fetching user document: \(error.localizedDescription)")
                    // Revert the local state if the update fails
                    DispatchQueue.main.async {
                        self.products[index].isFavorite.toggle()
                        self.objectWillChange.send()
                    }
                    return
                }
                
                guard let data = document?.data(),
                      var favorites = data["favorites"] as? [String] else {
                    print("⚠️ Unable to fetch or parse the 'favorites' array.")
                    // Revert the local state if the update fails
                    DispatchQueue.main.async {
                        self.products[index].isFavorite.toggle()
                        self.objectWillChange.send()
                    }
                    return
                }
                
                if isNowFavorite {
                    // Add the product to favorites
                    favorites.append(productID)
                } else {
                    // Remove the product from favorites
                    favorites.removeAll { $0 == productID }
                }
                
                print("ℹ️ Updating 'favorites' field in Firestore: \(favorites)")
                
                // Update Firestore
                userDocRef.updateData(["favorites": favorites]) { error in
                    if let error = error {
                        print("❌ Error updating 'favorites' in Firestore: \(error.localizedDescription)")
                        // Revert the local state if the update fails
                        DispatchQueue.main.async {
                            self.products[index].isFavorite.toggle()
                            self.objectWillChange.send()
                        }
                    } else {
                        print("✅ Successfully updated 'favorites' in Firestore.")
                    }
                }
            }
        } else {
            print("⚠️ Product with ID \(productID) not found in products.")
        }
    }
    
    
    private func trackCategoryClick(category: String) {
        
        let normalizedCategory = category.uppercased()
        let analyticsRef = firestore.collection("analytics").document("click_categories").collection("all").document(normalizedCategory)
        
        analyticsRef.getDocument { document, error in
            if let error = error {
                print("❌ Error fetching category analytics: \(error.localizedDescription)")
                return
            }
            
            if document?.exists == true {
                analyticsRef.updateData([
                    "clicks": FieldValue.increment(Int64(1))
                ]) { error in
                    if let error = error {
                        print("❌ Error updating category click: \(error.localizedDescription)")
                    } else {
                        print("✅ Category click incremented for '\(category)'.")
                    }
                }
            } else {
                analyticsRef.setData([
                    "count": 1
                ]) { error in
                    if let error = error {
                        print("❌ Error creating new category click: \(error.localizedDescription)")
                    } else {
                        print("✅ New category click tracked for '\(category)'.")
                    }
                }
            }
        }
    }
}
