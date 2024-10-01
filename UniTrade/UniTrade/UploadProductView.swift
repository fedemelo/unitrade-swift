//
//  UploadProductView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 25/09/24.
//

import SwiftUI

struct UploadProductView: View {
    @Environment(\.colorScheme) var colorScheme
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
                        Text(formFields[i].label).font(Font.DesignSystem.bodyText200)
                        TextField(formFields[i].placeholder, text: formFields[i].binding)
                            .textFieldStyle(.plain)
                            .font(Font.DesignSystem.bodyText100)
                            .keyboardType(["Price", "Rental Period"].contains(formFields[i].label) ? .decimalPad : .default)                .focused($focusedField, equals: fieldForIndex(i))
                            .onTapGesture {
                                focusedField = fieldForIndex(i)
                            }

                        if let errorMessage = fieldErrors[i] {
                            Text(errorMessage).foregroundColor(.red).font(.caption)
                        }
                    }
                }

                UploadImageButton(selectedImage: $viewModel.selectedImage)

                Button(action: {
                    viewModel.uploadProduct { success in
                        if success {
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
        .edgesIgnoringSafeArea(.bottom)
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
