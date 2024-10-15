import Foundation
import Combine
import FirebaseFirestore

class ExplorerViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var searchQuery: String = ""
    @Published var selectedCategory: String? = nil
    @Published var activeFilter = Filter()
    @Published var isDataLoaded = false
    
    private var cancellables = Set<AnyCancellable>()
    private let firestore = Firestore.firestore()
    
    init(categoryManager: ProductCategoryGroupManager) {
        
        
        // Subscribe to "For You" categories changes
        categoryManager.$forYouCategories
            .sink { [weak self] categories in
                print("📥 Received 'For You' categories: \(categories)")
                if !categories.isEmpty {
                    self?.selectedCategory = ProductCategoryGroupManager.Groups.foryou
                } else {
                    print("⚠️ 'For You' categories are empty")
                }
                self?.applyFilters()
            }
            .store(in: &cancellables)
        
        // Load products from Firestore on init
        loadProductsFromFirestore()
    }
    
    // Apply filters whenever data is ready or changes
    private func applyFilters() {
        if isDataLoaded {
            objectWillChange.send()  // Notify SwiftUI that filtering is happening
        } else {
            print("⚠️ Attempted to apply filters, but data is not fully loaded.")
        }
    }
    
    // Filter logic
    var filteredProducts: [Product] {
        guard isDataLoaded else {
            print("⚠️ Filtered products called but data is not loaded yet.")
            return []
        }
        
        print("🔍 Filtering products...")
        
        var filtered = products
        
        // Category filtering
        if let selectedCategory = selectedCategory {
            print("📂 Selected Category: \(selectedCategory)")
            if let categoryTags = ProductCategoryGroupManager().getCategories(for: selectedCategory) {
                filtered = filtered.filter { product in
                    let productCategoryArray = product.categories
                        .components(separatedBy: ",")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() }
                    
                    let normalizedTags = categoryTags.map { $0.uppercased() }
                    
                    let isMatching = productCategoryArray.contains { normalizedTags.contains($0) }
                    return isMatching
                }
            } else {
                print("⚠️ No matching tags found for category: \(selectedCategory)")
            }
        }
        
        // Search query filtering
        if !searchQuery.isEmpty {
            filtered = filtered.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }
        }
        
        print("✅ Filtered products count: \(filtered.count)")
        
        
        // Price range filtering
        if let minPrice = activeFilter.minPrice, let maxPrice = activeFilter.maxPrice {
            filtered = filtered.filter { product in
                let price = Double(product.price)
                return (minPrice == 0 || price >= minPrice) &&
                (maxPrice == 0 || price <= maxPrice)
            }
        }
        
        // Sorting based on filter option
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
    
    // Load products from Firestore
    func loadProductsFromFirestore() {
        print("📦 Fetching products from Firestore...")
        
        firestore.collection("products").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching products: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("⚠️ No products found in Firestore.")
                return
            }
            
            print("📄 Fetched \(documents.count) products from Firestore.")
            
            let fetchedProducts = documents.compactMap { doc -> Product? in
                guard let name = doc["name"] as? String,
                      let priceString = doc["price"] as? String,
                      let price = Float(priceString),
                      let categoriesArray = doc["categories"] as? [String],
                      let type = doc["type"] as? String else {
                    print("⚠️ Invalid data in document \(doc.documentID)")
                    return nil
                }
                let reviewCount: Int
                if let reviewCountValue = doc["review_count"] {
                    if let reviewCountString = reviewCountValue as? String, let convertedReviewCountString = Int(reviewCountString) {
                        reviewCount = convertedReviewCountString
                    } else if let reviewCountValueNumber = reviewCountValue as? NSNumber {
                        reviewCount = reviewCountValueNumber.intValue
                    } else {
                        print("⚠️ Invalid 'rating' value in document \(doc.documentID). Using default 0.0.")
                        reviewCount = 0
                    }
                } else {
                    reviewCount = 0
                }
                let rating: Float
                if let ratingValue = doc["rating"] {
                    if let ratingString = ratingValue as? String, let convertedRating = Float(ratingString) {
                        rating = convertedRating
                    } else if let ratingNumber = ratingValue as? NSNumber {
                        rating = ratingNumber.floatValue
                    } else {
                        print("⚠️ Invalid 'rating' value in document \(doc.documentID). Using default 0.0.")
                        rating = 0.0
                    }
                } else {
                    rating = 0.0
                }
                
                let imageUrl = (doc["image_url"] as? String)?.isEmpty == false
                ? doc["image_url"] as! String
                : "dummy"
                
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
                print("✅ Products loaded and ready: \(self.products.count) products")
                self.applyFilters()  // Apply filters after loading
            }
        }
    }
}
