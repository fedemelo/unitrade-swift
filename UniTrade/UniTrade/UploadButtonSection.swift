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
    
    var body: some View {
        Button(action: {
            viewModel.uploadProduct { success in
                alertMessage = success ? "Product uploaded successfully" :
                (viewModel.showReplaceAlert ? "No internet connection. A product is already waiting to upload." :
                    "No internet connection. Product saved locally.")
                showingAlert = true
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
        if alertMessage == "No internet connection. A product is already waiting to upload." {
            return Alert(
                title: Text("Upload Queue Full"),
                message: Text(alertMessage),
                primaryButton: .destructive(Text("Replace")) {
                    viewModel.replaceCachedProduct()
                    closeView()
                },
                secondaryButton: .cancel(Text("Dismiss"))
            )
        } else {
            return Alert(
                title: Text("Status"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) { closeView() }
            )
        }
    }
}
