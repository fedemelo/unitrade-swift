//
//  ProductUploadStrategies.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 30/09/24.
//

import SwiftUI

protocol ProductUploadStrategy {
    var title: String { get }

    func formFields(name: Binding<String>, description: Binding<String>, price: Binding<String>, rentalPeriod: Binding<String>, condition: Binding<String>) -> [(label: String, placeholder: String, binding: Binding<String>)]
}

struct SaleProductUploadStrategy: ProductUploadStrategy {
    var title: String {
        return "Sale"
    }

    func formFields(name: Binding<String>, description: Binding<String>, price: Binding<String>, rentalPeriod: Binding<String>, condition: Binding<String>) -> [(label: String, placeholder: String, binding: Binding<String>)] {
        return [
            ("Name", "Enter product name", name),
            ("Description", "Briefly describe the product", description),
            ("Price", "Enter price", price),
            ("Condition", "Describe the product's condition", condition)
        ]
    }
}

struct LeaseProductUploadStrategy: ProductUploadStrategy {
    var title: String {
        return "Lease"
    }

    func formFields(name: Binding<String>, description: Binding<String>, price: Binding<String>, rentalPeriod: Binding<String>, condition: Binding<String>) -> [(label: String, placeholder: String, binding: Binding<String>)] {
        return [
            ("Name", "Enter product name", name),
            ("Description", "Briefly describe the product", description),
            ("Price", "Enter price", price),
            ("Rental Period", "Enter rental period", rentalPeriod),
            ("Condition", "Describe the product's condition", condition)
        ]
    }
}
