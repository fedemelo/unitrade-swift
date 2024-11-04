import FirebaseAuth
import SwiftUI

extension Array {
    // This method splits the array into smaller arrays of the given size
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        for index in stride(from: 0, to: self.count, by: size) {
            let chunk = Array(self[index..<Swift.min(index + size, self.count)])
            chunks.append(chunk)
        }
        return chunks
    }
}

struct FirstTimeUserView: View {
    @ObservedObject var loginVM: LoginViewModel
    @State private var multiSelection = Set<CategoryName>()
    @State private var isLoading = false // Loading state for the Discover button
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottom) { // Overlay ZStack for banner
            
            NavigationView {
                VStack(spacing: 40) {
                    
                    Text("We want to know you better")
                        .font(Font.DesignSystem.headline800)
                        .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() :
                                            Color.DesignSystem.primary600())
                        .multilineTextAlignment(.center)
                    
                    Text("Choose the items you are interested in")
                        .font(Font.DesignSystem.bodyText300)
                    
                    VStack(spacing: 20) {
                        ForEach(Array(loginVM.categories.chunked(into: 2)), id: \.self) { rowCategories in
                            HStack(spacing: 10) {
                                Spacer()
                                
                                ForEach(rowCategories, id: \.self) { category in
                                    Button(action: {
                                        if multiSelection.contains(category) {
                                            multiSelection.remove(category)
                                        } else {
                                            multiSelection.insert(category)
                                        }
                                    }) {
                                        HStack {
                                            if multiSelection.contains(category) {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 10))
                                            }
                                            
                                            Text(category.name)
                                                .font(Font.DesignSystem.heading200)
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 16)
                                        .frame(minWidth: 100)
                                        .background(multiSelection.contains(category) ? Color.DesignSystem.primary900() : colorScheme == .light ? Color.white : Color.DesignSystem.dark900())
                                        .foregroundColor(multiSelection.contains(category) ?  Color.white  : colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                                        .cornerRadius(100)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 100)
                                                .stroke(Color.DesignSystem.primary900(), lineWidth: 2)
                                        )
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    
                    Button(action: {
                        if loginVM.isConnected {
                            isLoading = true
                            loginVM.registerUser(categories: multiSelection) {
                                // Callback after registration completes
                                isLoading = false
                                loginVM.showBanner = true // Show the banner after "Discover" is clicked
                            }
                        } else {
                            loginVM.showBanner = true // Show offline banner if not connected
                        }
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("DISCOVER")
                                .font(Font.DesignSystem.headline400)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.DesignSystem.primary900())
                    .foregroundColor(.white)
                    .cornerRadius(100)
                    .padding()
                }
                .padding(.horizontal)
            }
            
            // Warning banner at the bottom
            if loginVM.showBanner && !loginVM.isConnected {
                ZStack {
                    HStack {
                        Text("No internet connection. User information will be stored and uploaded when connection is available.")
                            .font(Font.DesignSystem.headline500)
                            .foregroundColor(Color.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // X button to close the banner
                        Button(action: {
                            loginVM.showBanner = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
                .background(Color.red)
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: loginVM.showBanner && !loginVM.isConnected) // Animation for banner
    }
}
