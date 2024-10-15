import Foundation
import FirebaseFirestore
import FirebaseAuth

class ProductCategoryGroupManager: ObservableObject {
    
    struct Groups {
        static let foryou = "For You"
        static let study = "Study"
        static let technology = "Tech"
        static let creative = "Creative"
        static let others = "Others"
        static let lab = "Lab"
        static let personal = "Personal"
    }

    static let productGroups: [String: [String]] = [
        Groups.study: ["TEXTBOOKS", "STUDY_GUIDES", "NOTEBOOKS", "CALCULATORS", "LAB MATERIALS"],
        Groups.technology: ["ELECTRONICS", "LAPTOPS & TABLETS", "CHARGERS", "CALCULATORS", "3D PRINTING", "ROBOTIC KITS"],
        Groups.creative: ["ART & DESIGN", "3D PRINTING", "MUSICAL INSTRUMENTS"],
        Groups.others: ["SPORTS", "MUSICAL INSTRUMENTS", "UNIFORMS"],
        Groups.lab: ["LAB MATERIALS", "ROBOTIC KITS", "3D PRINTING", "CALCULATORS"],
        Groups.personal: ["UNIFORMS", "CHARGERS", "LAPTOPS & TABLETS"]
    ]

    @Published var forYouCategories: [String] = []

    private let firestore = Firestore.firestore()

    // Fetch user-specific "For You" categories from Firestore
    func loadForYouCategories(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("Error: User is not authenticated.")
            completion(false)
            return
        }

        let userId = user.uid
        let userDocRef = firestore.collection("users").document(userId)

        userDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let document = document, document.exists,
                  let userCategories = document.data()?["categories"] as? [String] else {
                print("No preferred categories found for user \(userId).")
                completion(false)
                return
            }

            DispatchQueue.main.async {
                self.forYouCategories = userCategories
                print("Loaded 'For You' categories: \(userCategories)")
                completion(true)
            }
        }
    }

    // Retrieve categories by group name
    func getCategories(for group: String) -> [String]? {
        if group == Groups.foryou {
            return forYouCategories.isEmpty ? nil : forYouCategories
        }
        return ProductCategoryGroupManager.productGroups[group]
    }
}
