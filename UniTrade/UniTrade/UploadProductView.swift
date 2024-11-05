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
    @StateObject private var screenTimeViewModel = ScreenTimeViewModel()
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @FocusState private var focusedField: Field?
    
    
    private var SUCCESSFUL_UPLOAD_MESSAGE: String {
        "Product uploaded successfully"
    }
    private var NO_INTERNET_TO_UPLOAD: String {
        "No internet connection. Product saved locally and will be uploaded when you are back online."
    }
    private var NO_INTERNET_NO_QUEUE_MESSAGE: String {
        "No internet connection. A product is already waiting to upload. Connect to the internet to complete the upload, or replace the existing product with this one."
    }
    
    enum Field {
        case name, description, price, rentalPeriod, condition
    }
    
    init(strategy: UploadProductStrategy) {
        _viewModel = StateObject(wrappedValue: UploadProductViewModel(strategy: strategy))
    }
    
    private func closeView() {
        presentationMode.wrappedValue.dismiss()
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
                
                UploadImageButton(height: 160, selectedImage: $viewModel.selectedImage, isImageFromGallery: $viewModel.isImageFromGallery)
                
                
                
                Button(action: {
                    if viewModel.validateFields() {
                        viewModel.uploadProduct { success in
                            if success {
                                alertMessage = self.SUCCESSFUL_UPLOAD_MESSAGE
                            } else {
                                alertMessage = viewModel.showReplaceAlert ? self.NO_INTERNET_NO_QUEUE_MESSAGE : self.NO_INTERNET_TO_UPLOAD
                            }
                            showingAlert = true
                        }
                    }
                }) {
                    if viewModel.isUploading {
                        ProgressView()
                    } else {
                        Text("Upload Product")
                    }
                }
                .disabled(viewModel.isUploading)
                .alert(isPresented: $showingAlert) {
                    alertMessage == self.NO_INTERNET_NO_QUEUE_MESSAGE ?
                    
                    Alert(
                        title: Text("Upload Queue Full"),
                        message: Text(NO_INTERNET_NO_QUEUE_MESSAGE),
                        primaryButton: .destructive(Text("Replace")) {
                            viewModel.replaceCachedProduct()
                            closeView()
                        },
                        secondaryButton: .cancel(Text("Dismiss"))
                    ) :
                    
                    Alert(title: Text("Status"),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK")) {
                              closeView()
                          }
                    )
                }
                
                Spacer()
            }
            .padding()
            .padding(.horizontal)
            .onAppear {
                viewModel.observeNetworkChanges()
            }
        }
        .navigationTitle("Upload Product")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {screenTimeViewModel.startTrackingTime()}
        .onDisappear {screenTimeViewModel.stopAndRecordTime(for: "UploadProductView")}
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
