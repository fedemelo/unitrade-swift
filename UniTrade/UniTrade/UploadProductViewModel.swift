//
//  UploadProductViewModel.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 1/10/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

class UploadProductViewModel: ObservableObject {
    @Published var isImageFromGallery: Bool = true
    
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var price: String = ""
    @Published var formattedPrice: String = ""
    @Published var rentalPeriod: String = ""
    @Published var condition: String = ""
    @Published var selectedImage: UIImage?
    
    @Published var nameError: String? = nil
    @Published var descriptionError: String? = nil
    @Published var priceError: String? = nil
    @Published var rentalPeriodError: String? = nil
    @Published var conditionError: String? = nil
    
    var strategy: UploadProductStrategy
    
    private let storage = Storage.storage()
    private let firestore = Firestore.firestore()
    
    init(strategy: UploadProductStrategy) {
        self.strategy = strategy
    }
    
    private let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "COP"
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    func updatePriceInput(_ input: String) {
        let cleanedInput = input.filter { "0123456789".contains($0) }
        
        if let number = Double(cleanedInput) {
            price = String(number)
            formattedPrice = priceFormatter.string(from: NSNumber(value: number)) ?? ""
        } else {
            price = ""
            formattedPrice = ""
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
        if validateFields() {
            fetchCategories { categories in
                guard let categories = categories else {
                    print("Failed to fetch categories, aborting product upload.")
                    completion(false)
                    return
                }
                
                if let image = self.selectedImage {
                    self.uploadImage(image) { imageURL in
                        self.saveProductData(imageURL: imageURL, categories: categories, completion: completion)
                    }
                } else {
                    self.saveProductData(imageURL: nil, categories: categories, completion: completion)
                }
            }
        } else {
            completion(false)
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
        var productData: [String: Any] = [
            "name": name,
            "description": description,
            "price": price,
            "condition": condition,
            "categories": categories,
            "review_count": 0,
            "type": strategy.type,
            "user_id": "m8MoVH4chLRBr2dLEjuPzIe28sf1"  //TODO: get user id
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
                if let error = error {
                    print("Error uploading product: \(error)")
                    completion(false)
                } else {
                    print("Successfully uploaded product.")
                    completion(true)
                }
            }
    }
    
    
    
    private func validateFields() -> Bool {
        var isValid = true
        
        nameError = nil
        descriptionError = nil
        priceError = nil
        rentalPeriodError = nil
        conditionError = nil
        
        if name.isEmpty {
            nameError = "Please enter a name for the product"
            isValid = false
        }
        
        if description.isEmpty {
            descriptionError = "Please enter a description for the product"
            isValid = false
        }
        
        if price.isEmpty {
            priceError = "Please enter a price for the product"
            isValid = false
        } else if Double(price) == nil {
            priceError = "Please enter a valid number for the price"
            isValid = false
        }
        
        if strategy is LeaseProductUploadStrategy && rentalPeriod.isEmpty {
            rentalPeriodError = "Please enter a rental period "
            isValid = false
        }
        
        if condition.isEmpty {
            conditionError = "Please enter a condition for the product"
            isValid = false
        }
        
        return isValid
    }
}
