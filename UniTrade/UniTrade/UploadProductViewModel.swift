//
//  UploadProductViewModel.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 1/10/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import Foundation
import Combine
import FirebaseAuth
import NotificationCenter

extension Notification.Name {
    static let connectionRestoredAndProductUploaded = Notification.Name("connectionRestoredAndProductUploaded")
}

struct ProductCache: Codable {
    let name: String
    let description: String
    let price: String
    let condition: String
    let rentalPeriod: String?
    let imageData: Data?
}

class UploadProductViewModel: ObservableObject {
    @Published var isImageFromGallery: Bool = true
    
    @Published var formattedPrice: String = ""
    @Published var selectedImage: UIImage?
    
    @Published var nameError: String? = nil
    @Published var descriptionError: String? = nil
    @Published var priceError: String? = nil
    @Published var rentalPeriodError: String? = nil
    @Published var conditionError: String? = nil
    
    @Published var isUploading: Bool = false
    @Published var showReplaceAlert: Bool = false
    @Published private var isUploadingCachedProduct: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    var strategy: UploadProductStrategy
    private var networkMonitor = NetworkMonitor.shared
    private let cacheKey = "cachedProduct"
    
    private let storage = Storage.storage()
    private let firestore = Firestore.firestore()

    static var hasCachedProduct: Bool {
        return UserDefaults.standard.data(forKey: "cachedProduct") != nil
    }
    
    init(strategy: UploadProductStrategy) {
        self.strategy = strategy
        observeNetworkChanges()
    }
    
    @Published var name: String = "" {
        didSet {
            validateName()
        }
    }
    
    @Published var description: String = "" {
        didSet {
            validateDescription()
        }
    }
    
    @Published var price: String = "" {
        didSet {
            validatePrice()
        }
    }
    
    @Published var rentalPeriod: String = "" {
        didSet {
            validateRentalPeriod()
        }
    }
    
    @Published var condition: String = "" {
        didSet {
            validateCondition()
        }
    }
    
    var hasValidationErrors: Bool {
        return name.isEmpty 
        || description.isEmpty 
        || price.isEmpty 
        || (strategy is LeaseProductUploadStrategy && rentalPeriod.isEmpty) 
        || condition.isEmpty 
        || nameError != nil 
        || descriptionError != nil 
        || priceError != nil 
        || rentalPeriodError != nil 
        || conditionError != nil
    }
    
    func observeNetworkChanges() {
        networkMonitor.$isConnected
            .removeDuplicates()
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
            .sink { isConnected in
                if isConnected {
                    self.uploadCachedProduct()
                }
            }
            .store(in: &cancellables)
    }
    
    func cacheProductLocally() {
        var imageData: Data? = nil
        if let selectedImage = selectedImage {
            imageData = selectedImage.jpegData(compressionQuality: 0.8)
            if imageData == nil {
                print("Failed to convert image to data")
            }
        }
        
        let cachedProduct = ProductCache(
            name: name,
            description: description,
            price: price,
            condition: condition,
            rentalPeriod: rentalPeriod,
            imageData: imageData
        )
        
        // Check if there's already a product in cache
        if loadCachedProduct() != nil {
            showReplaceAlert = true  // Trigger alert in the view
            return
        }
        
        do {
            let data = try JSONEncoder().encode(cachedProduct)
            UserDefaults.standard.set(data, forKey: cacheKey)
            print("Product cached successfully")
        } catch {
            print("Error encoding cached product: \(error)")
        }
    }
    
    func replaceCachedProduct() {
        // Clear the old product and cache the new one
        UserDefaults.standard.removeObject(forKey: cacheKey)
        cacheProductLocally()
    }
    
    private func loadCachedProduct() -> ProductCache? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey),
              let cachedProduct = try? JSONDecoder().decode(ProductCache.self, from: data) else {
            return nil
        }
        return cachedProduct
    }
    
    private func uploadCachedProduct() {
        guard !self.isUploadingCachedProduct, let cachedProduct = loadCachedProduct() else { return }
        
        self.isUploadingCachedProduct = true

        if let imageData = cachedProduct.imageData, let image = UIImage(data: imageData) {
            selectedImage = image
        } else {
            selectedImage = nil
        }
        
        name = cachedProduct.name
        description = cachedProduct.description
        price = cachedProduct.price
        condition = cachedProduct.condition
        rentalPeriod = cachedProduct.rentalPeriod ?? ""
        
        uploadProduct { success in
            if success {                
                NotificationCenter.default.post(name: .connectionRestoredAndProductUploaded, object: nil)
                UserDefaults.standard.removeObject(forKey: self.cacheKey)
            }
            
            self.isUploadingCachedProduct = false
        }
    }
    
    func updatePriceInput(_ input: String) {
        let cleanedInput = input.filter { "0123456789".contains($0) }
        
        if let number = Float(cleanedInput) {
            // Update the raw price and formatted price at the same time
            let formattedNumber = CurrencyFormatter.formatPrice(number, currencySymbol: "$")
            price = formattedNumber
        } else {
            price = ""
        }
    }
    
    private func fetchCategories(completion: @escaping ([String]?) -> Void) {
        guard let url = URL(string: APIConfig.categoriesAPI) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let productDetails: [String: String] = [
            "condition": condition,
            "description": description,
            "name": name,
            "price": price
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: productDetails, options: []) else {
            print("Failed to serialize product details")
            completion(nil)
            return
        }
        
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching categories: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let categories = try JSONDecoder().decode([String].self, from: data)
                completion(categories)
            } catch {
                print("Error decoding categories: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func uploadProduct(completion: @escaping (Bool) -> Void) {
        if !self.hasValidationErrors {
            self.isUploading = true
            
            if networkMonitor.isConnected {
                let startTime = Date()
                
                fetchCategories { categories in
                    guard let categories = categories else {
                        print("Failed to fetch categories, aborting product upload.")
                        self.isUploading = false
                        completion(false)
                        return
                    }
                    
                    if let image = self.selectedImage {
                        self.uploadImage(image) { imageURL in
                            self.saveProductData(imageURL: imageURL, categories: categories) { success in
                                let endTime = Date()
                                let duration = endTime.timeIntervalSince(startTime)*1000
                                self.logUploadTimeToFirebase(duration: duration)
                                completion(success)
                                self.isUploading = false
                            }
                        }
                    } else {
                        self.saveProductData(imageURL: nil, categories: categories) { success in
                            let endTime = Date()
                            let duration = endTime.timeIntervalSince(startTime)*1000
                            self.logUploadTimeToFirebase(duration: duration)
                            completion(success)
                            self.isUploading = false
                        }
                    }
                }
            } else {
                cacheProductLocally()
                self.isUploading = false
                completion(false)
                print("No internet connection. Product saved locally.")
            }
        } else {
            completion(false)
        }
    }
    
    private func logUploadTimeToFirebase(duration: TimeInterval) {
        let db = Firestore.firestore()
        let analyticsRef = db.collection("analytics").document("upload_time")
        
        // Append the new duration to `listing_times`
        analyticsRef.updateData([
            "listing_times": FieldValue.arrayUnion([duration])
        ]) { error in
            if let error = error {
                print("Error logging upload time to Firebase: \(error)")
            } else {
                print("Successfully logged upload time to Firebase: \(duration) miliseconds")
            }
        }
    }
    
    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        let uuid: String = UUID().uuidString.lowercased()
        let storageRef = storage.reference().child("images/\(uuid).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            print("Error converting image to data")
            completion(nil)
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion(nil)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    completion(nil)
                    return
                }
                
                completion(url?.absoluteString)
            }
        }
    }
    
    private func saveProductData(imageURL: String?, categories: [String], completion: @escaping (Bool) -> Void) {
        let userId = Auth.auth().currentUser?.uid ?? ""
        if userId.isEmpty {
            print("User is not authenticated")
        }
        
        var productData: [String: Any] = [
            "name": name,
            "description": description,
            "price": price.replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: ".", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines),
            "condition": condition,
            "categories": categories,
            "review_count": 0,
            "favorites_category": 0,
            "favorites_foryou": 0,
            "favorites": 0,
            "type": strategy.type,
            "user_id": userId,
        ]
        
        if strategy is LeaseProductUploadStrategy {
            productData["rental_period"] = rentalPeriod
        }
        
        if let imageURL = imageURL {
            productData["image_url"] = imageURL
            productData["image_source"] = isImageFromGallery ? "gallery" : "camera"
        }
        
        firestore
            .collection("products")
            .document(UUID().uuidString.lowercased())
            .setData(productData) { error in
                self.isUploading = false
                if let error = error {
                    print("Error uploading product: \(error)")
                    completion(false)
                } else {
                    print("Successfully uploaded product.")
                    completion(true)
                }
            }
    }
    
    
    func validateName() {
        if name.isEmpty {
            nameError = "Please enter a name for the product"
        } else {
            let nameRegex = "^[\\w]+( [\\w]+)*$"
            let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
            nameError = !namePredicate.evaluate(with: name) ?
            "Product name must contain one or more words composed of alphanumeric characters with no trailing or leading spaces" : nil
        }
    }
    
    func validateDescription() {
        if description.isEmpty {
            descriptionError = "Please enter a description for the product"
        } else if description.count < 3 {
            descriptionError = "Description must be at least 3 characters long"
        } else if description.count > 140 {
            descriptionError = "Description cannot exceed 140 characters"
        } else {
            descriptionError = nil
        }
    }
    
    func validatePrice() {
        if price.isEmpty {
            priceError = "Please enter a price for the product"
        } else {
            let cleanedPrice = price
                .replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: ".", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let priceValue = Float(cleanedPrice), priceValue > 50, priceValue <= 90000000 {
                priceError = nil
            } else {
                priceError = cleanedPrice.isEmpty || Float(cleanedPrice) == nil
                ? "Please enter a valid number for the price"
                : "The price must be greater than $50 and less than $90.000.000"
            }
        }
    }
    
    func validateRentalPeriod() {
        if strategy is LeaseProductUploadStrategy {
            if rentalPeriod.isEmpty {
                rentalPeriodError = "Please enter a rental period"
            } else if let periodValue = Double(rentalPeriod), periodValue > 0, periodValue <= 365 {
                rentalPeriodError = nil
            } else {
                rentalPeriodError = rentalPeriod.isEmpty || Double(rentalPeriod) == nil
                ? "Please enter a valid number for the rental period"
                : "The rental period must be between 1 and 365 days"
            }
        }
    }
    
    func validateCondition() {
        if condition.isEmpty {
            conditionError = "Please enter a condition for the product"
        } else {
            let conditionRegex = "^[\\w]+( [\\w]+)*$"
            let conditionPredicate = NSPredicate(format: "SELF MATCHES %@", conditionRegex)
            conditionError = !conditionPredicate.evaluate(with: condition) ?
            "The product condition must contain one or more words composed of alphanumeric characters with no trailing or leading spaces" : nil
        }
    }
}
