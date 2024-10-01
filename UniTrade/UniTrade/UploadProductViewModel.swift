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
    @Published var rentalPeriod: String = ""
    @Published var condition: String = ""
    @Published var selectedImage: UIImage?

    var strategy: ProductUploadStrategy

    private let storage = Storage.storage()
    private let firestore = Firestore.firestore()

    init(strategy: ProductUploadStrategy) {
        self.strategy = strategy
    }

    func uploadProduct(completion: @escaping (Bool) -> Void) {
        if let image = selectedImage {
            uploadImage(image) { imageURL in
                self.saveProductData(imageURL: imageURL, completion: completion)
            }
        } else {
            saveProductData(imageURL: nil, completion: completion)
        }
    }

    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        let storageRef = storage.reference().child("images/\(UUID().uuidString).jpg")

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
            "type": strategy.title,
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
            .document(UUID().uuidString)
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
}
