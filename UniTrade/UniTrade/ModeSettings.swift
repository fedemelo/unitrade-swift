//
//  ModeSettings.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 20/10/24.
//

import SwiftUI

class ModeSettings: ObservableObject {
    @Published var selectedMode: LightDarkModeSettingsView.Mode {
        didSet {
            // Save the selected mode to UserDefaults whenever it changes
            switch selectedMode {
            case .light:
                UserDefaults.standard.set("light", forKey: "modeSetting")
            case .dark:
                UserDefaults.standard.set("dark", forKey: "modeSetting")
            case .automatic:
                UserDefaults.standard.set("automatic", forKey: "modeSetting")
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
}
