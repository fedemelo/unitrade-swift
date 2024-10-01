//
//  UploadProductForm.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 25/09/24.
//

import SwiftUI

struct UploadProductForm: View {
    @Environment(\.colorScheme) var colorScheme
    var strategy: ProductUploadStrategy

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var price: String = ""
    @State private var rentalPeriod: String = ""
    @State private var condition: String = ""
    @State private var selectedImage: UIImage?

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 30) {
                HStack {
                    Text(strategy.title)
                        .font(Font.DesignSystem.headline600)
                        .foregroundColor(Color.DesignSystem.dark500(for: colorScheme))
                    Spacer()
                }
                .frame(maxWidth: .infinity)

                let formFields = strategy.formFields(
                    name: $name,
                    description: $description,
                    price: $price,
                    rentalPeriod: $rentalPeriod,
                    condition: $condition)

                ForEach(0..<formFields.count, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(formFields[i].label).font(Font.DesignSystem.bodyText200)
                        TextField(formFields[i].placeholder, text: formFields[i].binding)
                            .textFieldStyle(.plain)
                            .font(Font.DesignSystem.bodyText100)
                    }
                }

                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                }
                UploadImageButton(selectedImage: $selectedImage)

                ButtonWithIcon(text: "UPLOAD PRODUCT", icon: "arrow.up.to.line.square")

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
