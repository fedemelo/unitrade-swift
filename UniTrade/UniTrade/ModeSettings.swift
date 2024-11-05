//
//  ModeSettings.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 20/10/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class ModeSettings: ObservableObject {
    @Published var selectedMode: LightDarkModeSettingsView.Mode {
        didSet {
            // Save selected mode to UserDefaults for persistence
            switch selectedMode {
            case .light:
                UserDefaults.standard.set("light", forKey: "modeSetting")
                updateFirestoreThemePreference(isAutomatic: false)
            case .dark:
                UserDefaults.standard.set("dark", forKey: "modeSetting")
                updateFirestoreThemePreference(isAutomatic: false)
            case .automatic:
                UserDefaults.standard.set("automatic", forKey: "modeSetting")
                updateFirestoreThemePreference(isAutomatic: true)
            }
        }
    }
    
    init() {
        // Retrieve the saved mode from UserDefaults when the app starts
        if let savedMode = UserDefaults.standard.string(forKey: "modeSetting") {
            switch savedMode {
            case "light":
                self.selectedMode = .light
            case "dark":
                self.selectedMode = .dark
            case "automatic":
                self.selectedMode = .automatic
            default:
                self.selectedMode = .automatic
            }
        } else {
            self.selectedMode = .automatic
        }
    }
    
    private func updateFirestoreThemePreference(isAutomatic: Bool) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).setData(["time_aware_theme": isAutomatic], merge: true) { error in
            if let error = error {
                print("Error updating theme preference: \(error)")
            } else {
                print("Theme preference successfully updated.")
            }
        }
    }
}
