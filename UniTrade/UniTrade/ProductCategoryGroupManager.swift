import Foundation

class ProductCategoryGroupManager: ObservableObject {
    
    // Group definitions
    struct Groups {
        static let foryou = "For You"
        static let study = "Study"
        static let technology = "Tech"
        static let creative = "Creative"
        static let others = "Others"
        static let lab = "Lab"
        static let personal = "Personal"
    }

    // Product categories by group
    static let productGroups: [String: [String]] = [
        Groups.study: ["TEXTBOOKS", "STUDY_GUIDES", "NOTEBOOKS", "CALCULATORS", "LAB MATERIALS"],
        Groups.technology: ["ELECTRONICS", "LAPTOPS & TABLETS", "CHARGERS", "CALCULATORS", "3D PRINTING", "ROBOTIC KITS"],
        Groups.creative: ["ART & DESIGN", "3D PRINTING", "MUSICAL INSTRUMENTS"],
        Groups.others: ["SPORTS", "MUSICAL INSTRUMENTS", "UNIFORMS"],
        Groups.lab: ["LAB MATERIALS", "ROBOTIC KITS", "3D PRINTING", "CALCULATORS"],
        Groups.personal: ["UNIFORMS", "CHARGERS", "LAPTOPS & TABLETS"]
    ]

    // Stores categories provided externally, such as from ExplorerViewModel
    @Published var forYouCategories: [String] = []

    // Retrieve categories for a specific group
    func getCategories(for group: String) -> [String]? {
        if group == Groups.foryou {
            // Return "For You" categories if available, else return nil
            return forYouCategories.isEmpty ? nil : forYouCategories
        }
        return ProductCategoryGroupManager.productGroups[group]
    }
}
