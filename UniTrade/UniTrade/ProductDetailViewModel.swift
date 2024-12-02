//
//  ProductDetailViewModel.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 2/12/24.
//

import Foundation
import Combine
import FirebaseFirestore
import Network
import FirebaseAuth

class ProductDetailViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var alertMessage = ""
    var dismissAction: (() -> Void)?

    private let firestore = Firestore.firestore()
    private var networkMonitor = NWPathMonitor()
    private var isConnected = true
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        monitorNetwork()
    }
    
    func handleBuyNow(for product: Product) {
        guard isConnected else {
            showNoInternetAlert()
            return
        }
        updateFirebase(for: product, isPurchase: true)
    }
    
    func handleRentNow(for product: Product) {
        guard isConnected else {
            showNoInternetAlert()
            return
        }
        updateFirebase(for: product, isPurchase: false)
    }
    
    private func updateFirebase(for product: Product, isPurchase: Bool) {
        guard let userId = Auth.auth().currentUser?.uid else {
            showAlert(message: "User is not authenticated.")
            return
        }
        
        let documentRef = firestore.collection("products").document(product.id)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        
        documentRef.updateData([
            "in_stock": false,
            "buyer_id": userId,
            "purchase_date": currentDate
        ]) { [weak self] error in
            if let error = error {
                self?.showAlert(message: "Failed to update product: \(error.localizedDescription)")
            } else {
                let successMessage = isPurchase
                    ? "Product purchased successfully!"
                    : "Product rented successfully!"
                self?.showAlert(message: successMessage)
            }
        }
    }
    
    private func showNoInternetAlert() {
        showAlert(message: "Please check your internet connection and try again.")
    }
    
    private func showAlert(message: String, dismiss: Bool = false) {
        alertMessage = message
        showAlert = true
        
        if dismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.dismissAction?()
            }
        }
    }
    
    private func monitorNetwork() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        networkMonitor.start(queue: queue)
    }
}
