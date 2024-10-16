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
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, description, price, rentalPeriod, condition
    }
    
    init(strategy: UploadProductStrategy) {
        _viewModel = StateObject(wrappedValue: UploadProductViewModel(strategy: strategy))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 30) {
                HStack {
                    Text(viewModel.strategy.title)
                        .font(Font.DesignSystem.headline600)
                        .foregroundColor(Color.DesignSystem.dark500(for: colorScheme))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
                let formFields = viewModel.strategy.formFields(
                    name: $viewModel.name,
                    description: $viewModel.description,
                    price: $viewModel.price,
                    rentalPeriod: $viewModel.rentalPeriod,
                    condition: $viewModel.condition
                )
                
                let fieldErrors = viewModel.strategy.fieldErrors(viewModel: viewModel)
                
                ForEach(0..<formFields.count, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(formFields[i].label)
                            .font(Font.DesignSystem.bodyText200)
                        
                        if formFields[i].label == "Price (COP)" {
                            TextField("", text: $viewModel.price)
                                .onChange(of: viewModel.price) { newValue, _ in
                                    viewModel.updatePriceInput(newValue)
                                }
                                .textFieldStyle(.plain)
                                .font(Font.DesignSystem.bodyText100)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: fieldForIndex(i))
                                .onTapGesture {
                                    focusedField = fieldForIndex(i)
                                }
                                .padding(.bottom, -5)
                        } else {
                            TextField("", text: formFields[i].binding)
                                .textFieldStyle(.plain)
                                .font(Font.DesignSystem.bodyText100)
                                .keyboardType(["Rental Period (days)"].contains(formFields[i].label) ? .decimalPad : .default)
                                .focused($focusedField, equals: fieldForIndex(i))
                                .onTapGesture {
                                    focusedField = fieldForIndex(i)
                                }
                                .padding(.bottom, -5)
                        }
                        
                        Divider().background(fieldErrors[i] != nil ? Color.red : Color.DesignSystem.dark800(for: colorScheme))
                        
                        if let errorMessage = fieldErrors[i] {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.top, -5)
                        }
                    }
                }
                
                UploadImageButton(selectedImage: $viewModel.selectedImage, isImageFromGallery: $viewModel.isImageFromGallery)
                
                
                Button(action: {
                    viewModel.uploadProduct { success in
                        if success {
                            presentationMode.wrappedValue.dismiss()
                            print("Product uploaded successfully!")
                        } else {
                            print("Failed to upload product")
                        }
                    }
                }) {
                    ButtonWithIcon(text: "UPLOAD PRODUCT", icon: "arrow.up.to.line.square")
                }
                
                Spacer()
            }
            .padding()
            .padding(.horizontal)
        }
        .navigationTitle("Upload Product")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func fieldForIndex(_ index: Int) -> Field {
        switch index {
        case 0: return .name
        case 1: return .description
        case 2: return .price
        case 3: return .rentalPeriod
        case 4: return .condition
        default: return .name
        }
    }
}
