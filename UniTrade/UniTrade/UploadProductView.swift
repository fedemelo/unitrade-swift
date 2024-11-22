//
//  UploadProductView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 25/09/24.
//

import SwiftUI

struct UploadProductView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: UploadProductViewModel
    @StateObject private var screenTimeViewModel = ScreenTimeViewModel()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, description, price, rentalPeriod, condition
    }
    
    init(strategy: UploadProductStrategy) {
        _viewModel = StateObject(wrappedValue: UploadProductViewModel(strategy: strategy))
    }
    
    private func closeView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 30) {
                UploadProductHeaderView(viewModel: viewModel, colorScheme: colorScheme)
                FormFieldsSection(
                    formFields: viewModel.strategy.formFields(
                        name: $viewModel.name,
                        description: $viewModel.description,
                        price: $viewModel.price,
                        rentalPeriod: $viewModel.rentalPeriod,
                        condition: $viewModel.condition
                    ),
                    fieldErrors: viewModel.strategy.fieldErrors(viewModel: viewModel),
                    focusedField: $focusedField,
                    colorScheme: colorScheme,
                    handleFieldChange: handleFieldChange
                )
                UploadImageButton(
                    height: 160,
                    selectedImage: $viewModel.selectedImage,
                    isImageFromGallery: $viewModel.isImageFromGallery
                )
                UploadButtonSection(
                    viewModel: viewModel,
                    showingAlert: $showingAlert,
                    alertMessage: $alertMessage,
                    closeView: closeView
                )
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.observeNetworkChanges()
            }
        }
        .navigationTitle("Upload Product")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { screenTimeViewModel.startTrackingTime() }
        .onDisappear { screenTimeViewModel.stopAndRecordTime(for: "UploadProductView") }
    }
    
    private func handleFieldChange(fieldIndex: Int, newValue: String) {
        switch fieldIndex {
        case 0:
            viewModel.validateName()
        case 1:
            viewModel.validateDescription()
        case 2:
            viewModel.validatePrice()
            viewModel.updatePriceInput(newValue)
        case 3:
            if viewModel.strategy is LeaseProductUploadStrategy {
                viewModel.validateRentalPeriod()
            } else {
                viewModel.validateCondition()
            }
        case 4:
            viewModel.validateCondition()
        default:
            break
        }
    }
}
