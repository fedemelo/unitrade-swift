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

    func uploadProduct(completion: @escaping (Bool) -> Void) {
        if validateFields() {
            if let image = selectedImage {
                uploadImage(image) { imageURL in
                    self.saveProductData(imageURL: imageURL, completion: completion)
                }
            } else {
                saveProductData(imageURL: nil, completion: completion)
            }
        } else {
            completion(false)
        }
    }

    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        let uuid: String = UUID().uuidString.lowercased()
        let storageRef = storage.reference().child("images/\(uuid).jpg")

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error converting image to data")
            completion(nil)
            return
        }

        storageRef.putData(imageData, metadata: nil) { metadata, error in
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

    private func saveProductData(imageURL: String?, completion: @escaping (Bool) -> Void) {
        var productData: [String: String] = [
            "name": name,
            "description": description,
            "price": price,
            "condition": condition,
            "type": strategy.type,
            // TODO: User id, once authentication is implemented
            "user_id": "m8MoVH4chLRBr2dLEjuPzIe28sf1"
        ]

        if strategy is LeaseProductUploadStrategy {
            productData["rentalPeriod"] = rentalPeriod
        }

        if let imageURL = imageURL {
            productData["imageUrl"] = imageURL
        }

        firestore
            .collection("products")
            .document(UUID().uuidString.lowercased())
            .setData(productData) {
                error in
                if let error = error {
                    print("Error saving product: \(error)")
                    completion(false)
                } else {
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
