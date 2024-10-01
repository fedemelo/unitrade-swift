//
//  UploadProductForm.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 25/09/24.
//

import SwiftUI

struct UploadProductForm: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel: UploadProductViewModel

    init(strategy: ProductUploadStrategy) {
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

                ForEach(0..<formFields.count, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(formFields[i].label).font(Font.DesignSystem.bodyText200)
                        TextField(formFields[i].placeholder, text: formFields[i].binding)
                            .textFieldStyle(.plain)
                            .font(Font.DesignSystem.bodyText100)
                            .keyboardType(formFields[i].label == "Price" ? .decimalPad : .default)
                    }
                }

                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Upload Product")
                    .foregroundColor(Color.DesignSystem.dark500(for: colorScheme))
                    .font(Font.DesignSystem.headline500)
            }
        }
    }
}
