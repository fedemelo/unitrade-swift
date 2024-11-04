import SwiftUI

struct LoginView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @State private var isLoading = false // Loading state for the Login button
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 20) {
                Spacer()
                
                Image("Image Auth")
                    .resizable()
                    .frame(width: 300, height: 300)
                
                Text("Discover the best offers")
                    .padding(.horizontal, 40)
                    .font(Font.DesignSystem.headline800)
                    .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.DesignSystem.primary600())
                    .multilineTextAlignment(.center)
                
                Text("Get all the materials for your classes without feeling that you’re paying too much.")
                    .font(Font.DesignSystem.bodyText300)
                    .foregroundColor(Color.DesignSystem.dark800(for: colorScheme))
                    .padding(.horizontal, 30)
                    .multilineTextAlignment(.center)
                    
                Spacer()
                
                Button(action: {
                    if loginViewModel.isConnected {
                        isLoading = true
                        loginViewModel.signIn {
                            // Callback after sign-in completes
                            isLoading = false
                        }
                    } else {
                        loginViewModel.showBanner = true // Show offline banner if not connected
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        HStack {
                            Image("Logo Microsoft")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Login with Microsoft")
                                .font(Font.DesignSystem.headline500)
                                .foregroundColor(Color.white)
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(25)
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .background(Color.DesignSystem.whitee(for: colorScheme))
            
            // Warning banner at the bottom
            if loginViewModel.showBanner && !loginViewModel.isConnected {
                ZStack {
                    HStack {
                        Text("No internet connection. Please try again when connected.")
                            .font(Font.DesignSystem.headline500)
                            .foregroundColor(Color.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // X button to close the banner
                        Button(action: {
                            loginViewModel.showBanner = false
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
        .animation(.easeInOut, value: loginViewModel.showBanner && !loginViewModel.isConnected) // Animation for banner
    }
}

struct LoginView_Previews: PreviewProvider {
    static var vm = LoginViewModel()
    
    static var previews: some View {
        LoginView(loginViewModel: vm)
    }
}
