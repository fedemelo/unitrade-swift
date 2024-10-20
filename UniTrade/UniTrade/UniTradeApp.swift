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

    func getColorSchemeBasedOnTime() -> ColorScheme {
        let currentHour = Calendar.current.component(.hour, from: Date())
        return (currentHour >= 6 && currentHour < 18) ? .light : .dark
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashScreenView(showSplash: $showSplash)
                } else if loginViewModel.registeredUser != nil && loginViewModel.firstTimeUser {
                    FirstTimeUserView(loginVM: loginViewModel)
                } else if loginViewModel.registeredUser != nil {
                    NavigationView {
                        MainView(loginViewModel: loginViewModel)
                    }
                } else {
                    LoginView(loginViewModel: loginViewModel)
                }
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
