//
//  UploadImageButton.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 25/09/24.
//

import SwiftUI

struct UploadImageButton: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var showActionSheet = false
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(15)
                    
                    Button(action: {
                        selectedImage = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.7)))
                    }
                    .offset(x: -10, y: 10)
                }
            } else {
                Button(action: {
                    showActionSheet = true
                }) {
                    VStack(spacing: 5) {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 35))
                            .foregroundColor(Color.DesignSystem.dark900())
                        
                        Text("Upload Image")
                            .font(Font.DesignSystem.bodyText200)
                            .foregroundColor(colorScheme == .light ? Color.DesignSystem.light400() : Color.DesignSystem.dark900())
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 50)
                }
                .background(colorScheme == .light ? Color.DesignSystem.light100() : Color.DesignSystem.light300())
                .cornerRadius(25)
                .actionSheet(isPresented: $showActionSheet) {
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
        .animation(.easeInOut, value: selectedImage)
    }
}
