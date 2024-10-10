//
//  ProductCategoryGroupManager.swift
//  UniTrade
//
//  Created by Santiago Martinez on 1/10/24.
//


import Foundation

struct ProductCategoryGroupManager {
    
    // Define all product categories as static constants
    struct Categories {
        static let textbooks = "TEXTBOOKS"
        static let studyGuides = "STUDY_GUIDES"
        static let electronics = "ELECTRONICS"
        static let laptopsTablets = "LAPTOPS & TABLETS"
        static let calculators = "CALCULATORS"
        static let chargers = "CHARGERS"
        static let labMaterials = "LAB MATERIALS"
        static let notebooks = "NOTEBOOKS"
        static let artDesign = "ART & DESIGN"
        static let roboticKits = "ROBOTIC KITS"
        static let threeDPrinting = "3D PRINTING"
        static let uniforms = "UNIFORMS"
        static let sports = "SPORTS"
        static let musicalInstruments = "MUSICAL INSTRUMENTS"
    }
    
    // Define all product groups as static constants
    struct Groups {
        static let study = "Study"
        static let technology = "Tech"
        static let creative = "Creative"
        static let others = "Others"
        static let lab = "Lab"
        static let personal = "Personal"
    }
    
    // A dictionary mapping groups to corresponding product categories
    static let productGroups: [String: [String]] = [
        Groups.study: [
            Categories.textbooks,
            Categories.studyGuides,
            Categories.notebooks,
            Categories.calculators,
            Categories.labMaterials
        ],
        Groups.technology: [
            Categories.electronics,
            Categories.laptopsTablets,
            Categories.chargers,
            Categories.calculators,
            Categories.threeDPrinting,
            Categories.roboticKits
        ],
        Groups.creative: [
            Categories.artDesign,
            Categories.threeDPrinting,
            Categories.musicalInstruments
        ],
        Groups.others: [
            Categories.sports,
            Categories.musicalInstruments,
            Categories.uniforms
        ],
        Groups.lab: [
            Categories.labMaterials,
            Categories.roboticKits,
            Categories.threeDPrinting,
            Categories.calculators
        ],
        Groups.personal: [
            Categories.uniforms,
            Categories.chargers,
            Categories.laptopsTablets
        ]
    ]
    
    // Method to retrieve categories for a specific group
    static func getCategories(for group: String) -> [String]? {
        return productGroups[group]
    }
}
