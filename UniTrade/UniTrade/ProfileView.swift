//
//  ProfileView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 19/10/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = ProfileViewModel()
    @StateObject private var screenTimeViewModel = ScreenTimeViewModel()
    @StateObject private var loginViewModel = LoginViewModel()
    
    let profileImageDiameter: CGFloat = 220
    
    var body: some View {
        VStack(spacing: 20) {
            // Profile Image
            HStack {
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: profileImageDiameter, height: profileImageDiameter)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                } else {
                    UploadImageButton(
                        height: profileImageDiameter,
                        selectedImage: $viewModel.selectedImage,
                        isImageFromGallery: $viewModel.isImageFromGallery
                    )
                    .frame(width: profileImageDiameter, height: profileImageDiameter)
                    .clipShape(Circle())
                }
            }
            
            // User Greeting
            if let userName = viewModel.userName {
                HStack(spacing: 5) {
                    Text("Hello,")
                        .font(Font.DesignSystem.headline600)
                        .foregroundColor(Color.DesignSystem.dark900(for: colorScheme))
                        .multilineTextAlignment(.center)
                    
                    Text(userName)
                        .font(Font.DesignSystem.headline600)
                        .foregroundColor(Color.DesignSystem.primary900(for: colorScheme))
                }
            } else {
                Text("Loading user information...")
                    .font(Font.DesignSystem.headline600)
                    .foregroundColor(Color.DesignSystem.dark900(for: colorScheme))
            }
            
            Spacer()
            
            List {
                Section {
                    NavigationLink(destination: MyListingsView()) {
                        Text("My Listings")
                    }
                    
                    NavigationLink(destination: MyOrdersView()) {
                        Text("My Orders")
                    }
                    
                    NavigationLink(destination: LightDarkModeSettingsView()) {
                        Text("Light/Dark Mode")
                    }
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(PlainListStyle())
            .background(Color.clear)
            
            Spacer()
            
            // Sign Out Button
            Button(action: {
                viewModel.signOut { success in
                    if success {
                        presentationMode.wrappedValue.dismiss()
                        print("Successfully signed out")
                    } else {
                        print("Failed to sign out")
                    }
                }
            }) {
                if viewModel.isSigningOut {
                    ProgressView()
                } else {
                    ButtonWithIcon(text: "SIGN OUT", icon: "power")
                }
            }
            .disabled(viewModel.isSigningOut)
            .padding(.bottom, 20)
        }
        .onAppear {
            viewModel.fetchUserName()
            screenTimeViewModel.startTrackingTime()
        }
        .padding()
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {screenTimeViewModel.stopAndRecordTime(for: "ProfileView")}
    }
}
