//
//  UniTradeApp.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    // Restrict the app to portrait mode only
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

@main
struct UniTradeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var modeSettings = ModeSettings()
    @State private var isSignedOut = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema()
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @StateObject var loginViewModel = LoginViewModel()
    @State private var showSplash = true
    @StateObject private var explorerViewModel = ExplorerViewModel()

    @State private var showConnectionRestoredAlert = false
    
    func getColorSchemeBasedOnTime() -> ColorScheme {
        let currentHour = Calendar.current.component(.hour, from: Date())
        return (currentHour >= 6 && currentHour < 18) ? .light : .dark
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashScreenView(showSplash: $showSplash)
                } else if loginViewModel.registeredUser != nil {
                    if loginViewModel.firstTimeUser {
                        FirstTimeUserView(loginVM: loginViewModel)
                    } else {
                        NavigationView {
                            MainView(loginViewModel: loginViewModel)
                        }
                    }
                } else {
                    LoginView(loginViewModel: loginViewModel, isSignedOut: $isSignedOut)
                }
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: .connectionRestoredAndProductUploaded, object: nil, queue: .main) { _ in
                    showConnectionRestoredAlert = true
                }

                // Simulate splash screen display time
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showSplash = false
                    }

                    // Check session after splash
                    if let currentUser = FirebaseAuthManager.shared.auth.currentUser {
                        loginViewModel.registeredUser = currentUser
                        loginViewModel.isFirstTimeUser()
                    }
                }

                explorerViewModel.fetchInitialDataInBackground()
            }
            .alert(isPresented: $showConnectionRestoredAlert) {
                Alert(
                    title: Text("Connection Restored"),
                    message: Text("Product uploaded successfully from local memory"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .environmentObject(modeSettings)
            .preferredColorScheme(
                modeSettings.selectedMode == .automatic
                    ? getColorSchemeBasedOnTime()
                    : (modeSettings.selectedMode == .light ? .light : .dark)
            )
        }
        .modelContainer(sharedModelContainer)
    }
}
