//
//  UserPreferences.swift
//  UniTrade
//
//  Created by Mariana on 4/11/24.
//


import SwiftUI

class UserPreferences: ObservableObject {
    @Published var preferredCategories: Set<CategoryName> {
        didSet {
            // Save preferred categories to UserDefaults whenever they change
            let categoryNames = preferredCategories.map { $0.name }
            UserDefaults.standard.set(categoryNames, forKey: "preferredCategories")
        }
    }
    
    @Published var preferredSemester: String {
        didSet {
            // Save preferred semester to UserDefaults whenever it changes
            UserDefaults.standard.set(preferredSemester, forKey: "preferredSemester")
        }
    }
    
    @Published var preferredMajor: String {
        didSet {
            // Save preferred major to UserDefaults whenever it changes
            UserDefaults.standard.set(preferredMajor, forKey: "preferredMajor")
        }
    }
    
    init() {
        // Retrieve saved categories from UserDefaults when the app starts
        if let savedCategories = UserDefaults.standard.array(forKey: "preferredCategories") as? [String] {
            self.preferredCategories = Set(savedCategories.map { CategoryName(name: $0) })
        } else {
            self.preferredCategories = []
        }
        
        // Retrieve saved semester from UserDefaults when the app starts
        self.preferredSemester = UserDefaults.standard.string(forKey: "preferredSemester") ?? "Select your Semester"
        
        // Retrieve saved major from UserDefaults when the app starts
        self.preferredMajor = UserDefaults.standard.string(forKey: "preferredMajor") ?? "Select your Major"
    }
}