//
//  UploadImageButton.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 25/09/24.
//

import SwiftUI

struct UploadImageButton: View {
    @Binding var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        VStack {
            Button(action: {
                showImagePicker = true
            }) {
                VStack (spacing: 5){
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 35))
                        .foregroundColor(Color.DesignSystem.dark900)

                    Text("Upload Image")
                        .font(Font.DesignSystem.bodyText200)
                        .foregroundColor(Color.DesignSystem.light400)
                        .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 50)   
            }
            .background(Color.DesignSystem.light100)
            .cornerRadius(25)
            .actionSheet(isPresented: $showImagePicker) {
                ActionSheet(title: Text("Select Image"), message: nil, buttons: [
                    .default(Text("Camera")) {
                        sourceType = .camera
                        showImagePicker = true
                    },
                    .default(Text("Photo Library")) {
                        sourceType = .photoLibrary
                        showImagePicker = true
                    },
                    .cancel()
                ])
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
            }
        }
    }
}
