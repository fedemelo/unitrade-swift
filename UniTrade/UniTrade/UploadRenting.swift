//
//  UploadRenting.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 25/09/24.
//

import SwiftUI


struct UploadRenting: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var price: String = ""
    @State private var condition: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            HStack {
               Text("Lease")
                   .font(Font.DesignSystem.headline600)
                   .foregroundColor(Color.DesignSystem.dark500Default)
               Spacer()
            }
            .frame(maxWidth: .infinity)
            
            let formFields: [(label: String, placeholder: String, binding: Binding<String>)] = [
                ("Name", "Enter product name", $name),
                ("Description", "Briefly describe the product", $description),
                ("Price", "Enter price", $price),
                ("Rental period", "Enter the rental period", $price),
                ("Condition", "Describe the product's condiiton", $condition)
            ]
            ForEach(0..<formFields.count, id: \.self) { i in
                VStack(alignment: .leading, spacing: 10) {
                    Text(formFields[i].label).font(Font.DesignSystem.bodyText200)
                    TextField(formFields[i].placeholder, text: formFields[i].binding).textFieldStyle(.plain)
                }
            }
            
            // TODO: Select Image
            
            IconButton(text: "UPLOAD PRODUCT", icon: "arrow.up.to.line.square")
            
            Spacer()
        }
        .padding()
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
