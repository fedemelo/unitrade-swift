//
//  ProductUploadStrategies.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 30/09/24.
//
import SwiftUI

protocol UploadProductStrategy {
    var title: String { get }
    var type: String { get }
    
    func formFields(
        name: Binding<String>,
        description: Binding<String>,
        price: Binding<String>,
        rentalPeriod: Binding<String>,
        condition: Binding<String>
    ) -> [(label: String, binding: Binding<String>)]

    func fieldErrors(viewModel: UploadProductViewModel) -> [String?]
}

struct SaleProductUploadStrategy: UploadProductStrategy {
    var title: String {
        return "Sale"
    }
    
    var type: String {
        return "sale"
    }

    func formFields(
        name: Binding<String>,
        description: Binding<String>,
        price: Binding<String>,
        rentalPeriod: Binding<String>,
        condition: Binding<String>
    ) -> [(label: String, binding: Binding<String>)] {
        return [
            ("Name", name),
            ("Description", description),
            ("Price (COP)", price),
            ("Condition", condition)
        ]
    }

    func fieldErrors(viewModel: UploadProductViewModel) -> [String?] {
        return [
            viewModel.nameError,
            viewModel.descriptionError,
            viewModel.priceError,
            viewModel.conditionError
        ]
    }
}

struct LeaseProductUploadStrategy: UploadProductStrategy {
    var title: String {
        return "Lease"
    }

    var type: String {
        return "lease"
    }

    func formFields(
        name: Binding<String>,
        description: Binding<String>,
        price: Binding<String>,
        rentalPeriod: Binding<String>,
        condition: Binding<String>
    ) -> [(label: String, binding: Binding<String>)] {
        return [
            ("Name", name),
            ("Description", description),
            ("Price (COP)", price),
            ("Rental Period (days)", rentalPeriod),
            ("Condition", condition)
        ]
    }

    func fieldErrors(viewModel: UploadProductViewModel) -> [String?] {
        return [
            viewModel.nameError,
            viewModel.descriptionError,
            viewModel.priceError,
            viewModel.rentalPeriodError,
            viewModel.conditionError
        ]
    }
}
