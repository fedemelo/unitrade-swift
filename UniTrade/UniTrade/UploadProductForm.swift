//
//  UploadProductForm.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 25/09/24.
//

import SwiftUI


struct UploadProductForm: View {
    var isSale: Bool

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
                    Text(isSale ? "Sale" : "Lease")
                        .font(Font.DesignSystem.headline600)
                        .foregroundColor(Color.DesignSystem.dark500Default)
                    Spacer()
                }
                .frame(maxWidth: .infinity)


                let formFields: [(label: String, placeholder: String, binding: Binding<String>)] = {
                    var fields = [
                        ("Name", "Enter product name", $name),
                        ("Description", "Briefly describe the product", $description),
                        ("Price", "Enter price", $price),
                        ("Condition", "Describe the product's condition", $condition)
                    ]

                    if !isSale {
                        fields.insert(("Rental period", "Enter the rental period", $price), at: 3)
                    }

                    return fields
                }()


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
                    .foregroundColor(Color.DesignSystem.dark500Default)
                    .font(Font.DesignSystem.headline500)
            }
        }
    }
}
