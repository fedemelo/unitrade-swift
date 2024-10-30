import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

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
    
    private var cancellables = Set<AnyCancellable>()
    private let firestore = Firestore.firestore()
    
    init() {
        loadForYouCategories { [weak self] success in
            if success {
                print("✅ 'For You' categories loaded successfully.")
                self?.selectedCategory = ProductCategoryGroupManager.Groups.foryou
            } else {
                print("⚠️ Failed to load 'For You' categories.")
            }
        }
    }
    
    func loadForYouCategories(completion: @escaping (Bool) -> Void) {
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
                completion(true)
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
        
        print("🔍 Filtering products...")
        var filtered = products
        
        if let selectedCategory = selectedCategory {
            print("📂 Selected Category: \(selectedCategory)")
            
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
        
        print("✅ Filtered products count: \(filtered.count)")
        
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
    
    func loadProductsFromFirestore() {
        print("📦 Fetching products from Firestore...")
        
        firestore.collection("products").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching products: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("⚠️ No products found.")
                return
            }
            
            let fetchedProducts = documents.compactMap { doc -> Product? in
                guard let name = doc["name"] as? String,
                      let priceString = doc["price"] as? String,
                      let price = Float(priceString),
                      let categoriesArray = doc["categories"] as? [String],
                      let type = doc["type"] as? String else {
                    print("⚠️ Invalid data in document \(doc.documentID)")
                    return nil
                }
                
                let reviewCount = (doc["review_count"] as? NSNumber)?.intValue ?? 0
                let rating = (doc["rating"] as? NSNumber)?.floatValue ?? 0.0
                let imageUrl = (doc["image_url"] as? String) ?? "dummy"
                let categories = categoriesArray.joined(separator: ", ")
                
                return Product(
                    title: name,
                    price: price,
                    rating: rating,
                    reviewCount: reviewCount,
                    isInStock: type,
                    categories: categories,
                    imageUrl: imageUrl
                )
            }
            
            DispatchQueue.main.async {
                self.products = fetchedProducts
                self.isDataLoaded = true
                print("✅ Products loaded: \(self.products.count)")
                self.applyFilters()
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
