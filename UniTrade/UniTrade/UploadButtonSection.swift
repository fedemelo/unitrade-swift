//
//  UploadButtonSection.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 19/11/24.
//

import SwiftUI

struct UploadButtonSection: View {
    @ObservedObject var viewModel: UploadProductViewModel
    @Binding var showingAlert: Bool
    @Binding var alertMessage: String
    let closeView: () -> Void
    
    private var SUCCESSFUL_UPLOAD_MESSAGE: String {
        "Product uploaded successfully"
    }
    private var PRODUCT_CACHED_NO_INTERNET: String {
        "No internet connection. Product saved locally and will be uploaded when you are back online."
    }
    private var NO_INTERNET_FULL_CACHE: String {
        "No internet connection. A product is already waiting to upload. Connect to the internet to complete the upload, or replace the existing product with this one."
    }
    
    var body: some View {
        Button(action: {
            if UploadProductViewModel.hasCachedProduct {
                alertMessage = self.NO_INTERNET_FULL_CACHE
                showingAlert = true
            } else {
                viewModel.uploadProduct { success in
                    if success {
                        alertMessage = self.SUCCESSFUL_UPLOAD_MESSAGE
                    } else {
                        alertMessage = self.PRODUCT_CACHED_NO_INTERNET
                    }
                    showingAlert = true
                }
            }
        }) {
            if viewModel.isUploading {
                ProgressView()
            } else {
                ButtonWithIcon(
                    text: "UPLOAD PRODUCT",
                    icon: "arrow.up.to.line.square",
                    isDisabled: viewModel.isUploading || viewModel.hasValidationErrors
                )
            }
        }
        .disabled(viewModel.isUploading || viewModel.hasValidationErrors)
        .alert(isPresented: $showingAlert) {
            createAlert()
        }
    }
    
    private func createAlert() -> Alert {
        if alertMessage == self.NO_INTERNET_FULL_CACHE {
            return Alert(
                title: Text("Upload Queue Full"),
                message: Text(alertMessage),
                primaryButton: .destructive(Text("Replace")) {
                    viewModel.replaceCachedProduct()
                    closeView()
                },
                secondaryButton: .cancel(Text("Dismiss")) {
                    closeView()
                }
            )
        } else {
            return Alert(
                title: Text("Status"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    closeView()
                }
            )
        }
    }
}
